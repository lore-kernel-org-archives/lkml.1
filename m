Return-Path: <linux-kernel-owner+w=401wt.eu-S932927AbXBAWjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbXBAWjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932998AbXBAWjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:39:52 -0500
Received: from ns.suse.de ([195.135.220.2]:47036 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927AbXBAWju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:39:50 -0500
From: Neil Brown <neilb@suse.de>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Date: Fri, 2 Feb 2007 09:39:21 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17858.27673.476380.463938@notabene.brown>
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>, nfs@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [NFS] 2.6.17.8 - do_vfs_lock: VFS is out of sync with lock manager!
In-Reply-To: message from Jesper Juhl on Wednesday January 31
References: <9a8748490608080739w2e14e5ceg44a7bf0a3b475704@mail.gmail.com>
	<17636.4462.975774.528003@cse.unsw.edu.au>
	<9a8748490608170258s32df0272r60c8c540e5871485@mail.gmail.com>
	<17641.10665.116168.867041@cse.unsw.edu.au>
	<1156190098.6158.109.camel@localhost>
	<17853.33116.113629.65031@notabene.brown>
	<1170080210.5757.6.camel@lade.trondhjem.org>
	<9a8748490701301542r33317ca7id9deb63fca2fb2dc@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday January 31, jesper.juhl@gmail.com wrote:
> On 29/01/07, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> Finally getting that in will be sooooo nice :-)  Thank you.
> 
> Btw: any reason why not to include the
>   fl->fl_flags &= ~FL_SLEEP;
> bit as well?  As in http://lkml.org/lkml/2006/11/27/41  ??
> 

Uhmm... I guess I had forgotten it ....

Looking again, I cannot convince myself that it is needed.
The comment says "If we were signalled ...", and if we were signalled
then do_vfs_lock won't block anyway.  I think I was probably being
over-cautious as I didn't know the significance of testing for
-ERESTARTSYS.
However it seems to only get returned if a signal is pending (so why
EINTR isn't returned I still don't know) so a signal must be pending
on that piece of code, so there is no need to clear FL_SLEEP.

Thanks,
NeilBrown
