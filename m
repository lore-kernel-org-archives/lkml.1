Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZERQbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZERQbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZERQa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:30:57 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:50987 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZERQaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:30:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=WEyB3bRC6HcvQd//Y7JCqD17WrxAjGyBqQ/nCHBqI6sbQYrpU00SPyj0+y3/d7DEMA
         fzT5jUa58lc2MAhXJKTjvbla3eEXaSh+P9H4S/p/1Y0cKX6d7ClqZrQ+5rwN52ws9Ta3
         xVwf1ADK4g5P9fAnDZFq89G4k2iGYmIIazXPQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
Date: Mon, 18 May 2009 18:35:28 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Helge Deller <deller@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <20090517133210.GB4640@nowhere> <20090517161916.GA2976@liondog.tnic>
In-Reply-To: <20090517161916.GA2976@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905181835.28803.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 May 2009 18:19:16 Borislav Petkov wrote:
> Hi,
> 
> On Sun, May 17, 2009 at 03:32:11PM +0200, Frederic Weisbecker wrote:
> > On Sun, May 17, 2009 at 09:33:27AM +0200, Ingo Molnar wrote:
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13297
> > > > Subject		: kernel panic -  not syncing : fatel exception in interupt
> > > > Submitter	: rob <rob1@housetosell.net>
> > > > Date		: 2009-05-12 19:34 (5 days old)
> > > > References	: http://marc.info/?l=linux-kernel&m=124216126903309&w=4
> > > 
> > > tainted crash, but probably legit. It does show some badness in an 
> > > old-IDE legacy codepath:
> > > 
> > > [<c0371865>] error_code+0x65/0x6c
> > > [<c0110155>] do_page_fault+0x0/0x1e0
> > > [<c027dafc>] ide_complete_rq+0xf/0x3b
> > > [<c02870a0>] cdrom_newpc_intr+0x64d/0x6cd
> > > [<c0286a53>] cdrom_newpc_intr+0x0/0x6cd
> > > [<c027dcc2>] ide_intr+0x109/0x161
> > > [<c0132298>] handle_IRQ_event+0x54/0xc7
> > > [<c013354a>] handle_level_irq+0x4f/0x85
> > > [<c0103df7>] handle_irq+0x17/0x20
> > > [<c0103da5>] do_IRQ+0x2b/0x66
> > > [<c0102be9>] common_interupt+0x29/0x30
> > > [<c0480000>] cmd40x_init+0x2ac/0x38d
> > > [<c0106db3>] default_idle+0x25/0x38
> > > [<c01019be>] cpu_idle+0x19/0x2d
> > > [<c0468907>] start_kernel+0x23f/0x242
> > > 
> > > report subject line is too unspecific, it should be changed to 
> > > something like:
> > > 
> > >   legacy IDE cmd40x related bootup crash
> > 
> > 
> > It seems the crash has been rewritten by hand. I don't see
> > any cmd40x_init(), I guess it's about cmd640 chipset, then
> > cmd640x_init()

Frederic, is the oops reproducible?  Is 2.6.30-rc6 any better?

Does it help if you disable CONFIG_BLK_DEV_CMD640?
(this system doesn't have CMD640 chipset)
