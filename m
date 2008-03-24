Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbYCXIuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbYCXIuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 04:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYCXItx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 04:49:53 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34109 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbYCXItw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 04:49:52 -0400
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
From: Ram Pai <linuxram@us.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trond.Myklebust@netapp.com, dhowells@redhat.com
In-Reply-To: <20080320214319.GS10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu>
	 <20080313212735.741834181@szeredi.hu>
	 <20080319114844.GK10722@ZenIV.linux.org.uk>
	 <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu>
	 <20080319182005.GP10722@ZenIV.linux.org.uk>
	 <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu>
	 <20080320214319.GS10722@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 01:50:14 -0700
Message-Id: <1206348614.2961.21.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-20 at 21:43 +0000, Al Viro wrote:
> On Wed, Mar 19, 2008 at 07:37:51PM +0100, Miklos Szeredi wrote:
> 
> > > Argh...  OK, I'll try to put something together tonight, after I get some
> > > sleep - 31 hours of uptime _suck_ ;-/
> > 
> > Gosh, yes.
> 
.....snip...
> Is there any reason why we do that in ->umount_begin() and not *after*
> it, unconditionally, straight from do_umount()?  AFAICS, the only reason
> why it's done from fs-specific code is figuring out which mount-list
> should the stuff go back to, and that's both broken *and* not needed
> with sanitized locking as above.  While we are at it, I'd rather return
> ->umount_begin() to its previous prototype, TYVM - the less filesystem
> sees vfsmounts, the better off we all are...

I think that ->umount_begin also acts a hook for providing pre-umount
event notification to userspace from filesystems; something that is
required by DMAPI interface.

RP

> 
> Comments?  If nobody objects, I'm going to do that in vfs-fixes branch
> and then push to Linus...

