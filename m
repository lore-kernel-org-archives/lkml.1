Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbYBWQKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbYBWQKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 11:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYBWQKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 11:10:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39574 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbYBWQKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 11:10:19 -0500
Date: Sat, 23 Feb 2008 16:09:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, serue@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       haveblue@us.ibm.com
Subject: Re: [patch 00/10] mount ownership and unprivileged mount syscall (v8)
Message-ID: <20080223160956.GR27894@ZenIV.linux.org.uk>
References: <20080205213616.343721693@szeredi.hu> <20080214222103.a5d8f4fe.akpm@linux-foundation.org> <20080215090120.GA6266@infradead.org> <20080215010951.163fe10e.akpm@linux-foundation.org> <20080215091438.GA24386@infradead.org> <E1JR4TX-000392-Cu@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JR4TX-000392-Cu@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 12:47:59PM +0100, Miklos Szeredi wrote:
> So what should I do?
> 
> Would Al be wanting to merge this into his VFS tree?  (Can't find it
> on git.kernel.org yet, BTW.)

FWIW, it's on hera right now, should propagate to git.kernel.org in a few.

Branches I'd pushed there: vfs-fixes.b0 and ro-bind.b0.  The latter is
on top of the former.  There will be more, but that at least takes care
of the most urgent stuff.  Again, apologies for things being too damn
slow ;-/

As for the unprivileged mounts...
	a) why do we lose them on clone() in new namespace?  Bloody
inconvenient, to put it mildly.
	b) why do we prohibit all kinds of remount?
	c) just what is limited by that sysctl?  AFAICS, rbind is allowed
if mountpoint is on user vfsmount and it seems to create vfsmounts without
eating into that limit just fine...  What's the point of limiting the
amount of vfsmounts marked user when you do not limit the number of vfsmount
one can allocate?
