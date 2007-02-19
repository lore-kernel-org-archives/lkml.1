Return-Path: <linux-kernel-owner+w=401wt.eu-S932142AbXBSLpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbXBSLpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932143AbXBSLpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:45:50 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:26686 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbXBSLpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:45:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QwZl7PjaKYMVsKiseXz6uPIGVd/siWr9EaOWdXX8U168rLaWi5qKSEppT6OJe1dXlA1z//F6p7x+YwwZUV9aj5oJP5lh2ASKWAGlLmOz53qklJlyzHSEf41AlfQ6TaKNat+djbczBFoqTsBAMvVZEzbt23jBeG9ChpdsUebUXTE=
Message-ID: <6bffcb0e0702190345p33f4832epec92656fff087f57@mail.gmail.com>
Date: Mon, 19 Feb 2007 12:45:47 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.20-mm2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Neil Brown" <neilb@suse.de>, "Jeff Garzik" <jeff@garzik.org>,
       linux-ide@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <200702191228.30599.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
	 <200702190025.49273.rjw@sisk.pl>
	 <20070218160026.2988d59f.akpm@linux-foundation.org>
	 <200702191228.30599.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, 19 February 2007 01:00, Andrew Morton wrote:
> > On Mon, 19 Feb 2007 00:25:48 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >
> > > > netconsole is good.
> > >
> > > I know. :-)
> > >
> > > In the meantime, I've got something worse on another x86_64 box:
> > >
> > > Asus Laptop ACPI Extras version 0.30
> > >   L5D model detected, supported
> > > audit(1171831698.918:2): audit_pid=4281 old=0 by auid=4294967295
> > > general protection fault: 0000 [2] PREEMPT
> > > last sysfs file: /class/net/eth2/carrier
> > > CPU 0
> > > Modules linked in: af_packet ipv6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device asus_acpi backlight button battery ac dm_mod pcmr
> > > Pid: 178, comm: pdflush Not tainted 2.6.20-mm2 #1
> > > RIP: 0010:[<ffffffff8034bce4>]  [<ffffffff8034bce4>] __make_request+0x134/0x370
> > > RSP: 0000:ffff81005ed659a0  EFLAGS: 00010297
> > > RAX: 00000000ffffffff RBX: 6b6b6b6b6b6b6b6b RCX: 000000000203396a
> > > RDX: 0000000100000000 RSI: ffff810037b4dbb0 RDI: ffff81004683d8c0
> > > RBP: ffff81005ed659f0 R08: ffff81004683d070 R09: ffff81003d333cc0
> > > R10: 0000000000000000 R11: 0000000000000000 R12: ffff810037b4dbb0
> > > R13: ffff81005daba3f0 R14: ffff810037daca90 R15: ffff81005daba3d0
> > > FS:  00002ad4a29e6d00(0000) GS:ffffffff805db000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > > CR2: 00002b6a345aa000 CR3: 0000000056585000 CR4: 00000000000006e0
> > > Process pdflush (pid: 178, threadinfo ffff81005ed64000, task ffff810037b060c0)
> > > Stack:  ffff810002852540 0000000000000001 ffff810037b4dbb0 ffffffff8026be21
> > >  ffff81005ed65a40 0000000000000008 ffff810037b4dbb0 0000000000000800
> > >  0000000000000008 ffff8100021d94e0 ffff81005ed65a40 ffffffff80348e7c
> > > Call Trace:
> > >  [<ffffffff8026be21>] mempool_alloc_slab+0x11/0x20
> > >  [<ffffffff80348e7c>] generic_make_request+0x1ec/0x230
> >
> > yeah. everyone except me is hitting that.
>
> FWIW, I don't see it on an SMP machine.
>

I can reproduce this on my SMT P4.

CONFIG_SMP=y
CONFIG_X86_PC=y
CONFIG_MPENTIUM4=y
CONFIG_NR_CPUS=2
CONFIG_SCHED_SMT=y

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
