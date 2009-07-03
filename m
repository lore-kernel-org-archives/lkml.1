Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZGCIYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZGCIYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZGCIYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:24:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44908 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZGCIYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:24:05 -0400
Date: Fri, 3 Jul 2009 10:20:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>
Subject: Re: mmotm 2009-06-30-12-50 dies during early boot
Message-ID: <20090703081821.GA4051@redhat.com>
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org> <11314.1246585948@turing-police.cc.vt.edu> <20090702192047.10b81ada.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702192047.10b81ada.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Andrew Morton wrote:
>
> On Thu, 02 Jul 2009 21:52:28 -0400 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Tue, 30 Jun 2009 12:51:30 PDT, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2009-06-30-12-50 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > (Would have gotten this out the door earlier, but I got confused about what
> > that 'G' in the 'Tainted' meant, and put off reporting till I could reproduce
> > it without the NVidia driver. Turns out it was untainted except for the
> > warning I already reported...)
> > 
> > Dies fairly early during boot, somewhere in the first few lines of rc.sysinit.
> > 
> > It *looks* like it dies in this call:
> > 
> > 	wake_up_interruptible(&current->real_parent->signal->wait_chldexit);

Thanks! I'll send the patch soon.

selinux_commited_creds() should use __wake_up_parent(), it should not play
with ->wait_cldexit directly.


I wanted to fix this before,  but __wake_up_parent() was not exported.
And now I forgot to do this when added child_wait_callback().

My fault.

Oleg.

