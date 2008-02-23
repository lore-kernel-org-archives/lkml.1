Return-Path: <linux-kernel-owner+w=401wt.eu-S1762051AbYBWS5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762051AbYBWS5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbYBWS5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:57:44 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57984 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbYBWS5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:57:43 -0500
Date: Sat, 23 Feb 2008 18:57:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, serue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       haveblue@us.ibm.com
Subject: Re: [patch 00/10] mount ownership and unprivileged mount syscall (v8)
Message-ID: <20080223185701.GS27894@ZenIV.linux.org.uk>
References: <20080205213616.343721693@szeredi.hu> <20080214222103.a5d8f4fe.akpm@linux-foundation.org> <20080215090120.GA6266@infradead.org> <20080215010951.163fe10e.akpm@linux-foundation.org> <20080215091438.GA24386@infradead.org> <E1JR4TX-000392-Cu@pomaz-ex.szeredi.hu> <20080223160956.GR27894@ZenIV.linux.org.uk> <E1JSyFN-0003dA-0a@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JSyFN-0003dA-0a@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 06:33:13PM +0100, Miklos Szeredi wrote:
> > 	c) just what is limited by that sysctl?  AFAICS, rbind is allowed
> > if mountpoint is on user vfsmount and it seems to create vfsmounts without
> > eating into that limit just fine...  What's the point of limiting the
> > amount of vfsmounts marked user when you do not limit the number of vfsmount
> > one can allocate?
> 
> The limit is there, so that unprivileged users cannot create insane
> number of mounts.  It's just a safety thing, analogous to
> /proc/sys/fs/file-max.

Can't they?  Looks like one can create any number of vfsmounts without
getting more than one marked MNT_USER...

What are you trying to limit - vfsmounts or superblocks?  The former is
not limited in your patchset at all, AFAICS - you can
do while true; do
	mount --bind /bin ~/my_directory;
	mount --bind /sbin ~/my_directory;
done
indefinitely and all the bleeding stack of vfsmounts will be !MNT_USER.
Or any number of similar schemes, really, without overmounting if you
wish to avoid it.

If you are trying to limit the number of superblocks (i.e. active instances
of filesystems), then I'd say that vfsmounts make piss-poor proxies for
those and it would be better to count the objects you really want to count...
