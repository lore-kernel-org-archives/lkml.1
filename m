Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbXIQJ54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbXIQJ54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbXIQJ5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:57:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:59028 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbXIQJ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=phZghgRIr0AXS3lRNEnX4Ox6Yu4ys3AEPiOJ52PLvQLIiw1xT+sEiTWkBSL9VDSvmfYDQIWxxeT6X0M0Fr/K1xv3Qxd87Iu+v910jqXslxYd573xOOeSs7Hw1tosxZOn5VL8+lJZQto3BlNxJIUIwauyLfWS9zYOU9xdqIVtJbw=
Message-ID: <ac0be4d70709170257o62e856f4re049c968ab5590a7@mail.gmail.com>
Date: Mon, 17 Sep 2007 13:57:43 +0400
From: "Sergey Dolgov" <dolgovs@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: ata_piix, laptop cdrom, ICH7: EH, limiting speed to PIO
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <46ED19F0.8060205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070911212030.GA2817@slk.laptop>
	 <6bffcb0e0709120933p6d58127fv3c85076fe41daaca@mail.gmail.com>
	 <20070912200706.GA2620@slk.laptop> <46E849B7.9040402@googlemail.com>
	 <20070912212025.GB2620@slk.laptop> <46E8663E.3080205@googlemail.com>
	 <46ED19F0.8060205@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/16/07, Tejun Heo <htejun@gmail.com> wrote:
> Michal Piotrowski wrote:
> > Sergey Dolgov pisze:
> >> On Wed, Sep 12, 2007 at 10:19:03PM +0200, Michal Piotrowski wrote:
> >>> Sergey Dolgov pisze:
> >>>> Hi Michal,
> >>>>
> >>>> On Wed, Sep 12, 2007 at 06:33:20PM +0200, Michal Piotrowski wrote:
> >>>>> Hi Sergey,
> >>>>>
> >>>>> On 11/09/2007, Sergey Dolgov <dolgovs@gmail.com> wrote:
> >>>>>> Hi!
> >>>>>>
> >>>>>> On my hp nx7300 laptop, 2 following scenarios can happen during bootup
> >>>>>> (see attachments for the full logs): the "good" one [1] and the one
> >>>>>> where multiple EHs lead to limiting the speed [2].
> >>>>>>
> >>>>>> [1] one is more rare, but it seems to be persistent over reboots: once
> >>>>>> it happened, just rebooting the machine always results in behaviour
> >>>>>> like [1].
> >>>>>>
> >>>>>> [1] results in a working cdrom from the start. An attempt to use cdrom
> >>>>>> after [2] happened results in even more EHs, resulting in "configured
> >>>>>> for PIO4", after which the cdrom is finaly working.
> >>>>>>
> >>>>>> The version I'm using is 2.6.23-rc6, but the same used to happen with
> >>>>>> the previous rc's, and probably with 2.6.22 too (I can check).
> >>>>> It would be great if you could check it.
> >>>> I've just built 2.6.22.6 with basically the same configuration, and
> >>>> the behaviour is just the same, i.e. both [1] and [2] still can
> >>>> happen.
> >>> Ok, thanks.
> >>>
> >>> BTW please check cables and PCU.
> >> What's a PCU?
> >
> > s/PCU/PSU - power supply unit
> >
> >> BTW, this only happens when using libata of course. The
> >> old CONFIG_IDE stuff works fine every time.
> >
> > This maybe one of libata weirdness (I really don't get it why some hardware
> > works perfectly fine with an old IDE and don't work well with libata).
>
> Hmmm... Is MWDMA2 mode used with ide driver too?
>

What's the best way to tell whether it does or not? (the log says
"selected mode 0x22", see below)

[    9.267682] ICH7: IDE controller at PCI slot 0000:00:1f.1
[    9.267776] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level,
low) -> IRQ 16
[    9.267928] ICH7: chipset revision 1
[    9.267998] ICH7: not 100% native mode: will probe irqs later
[    9.268088]     ide0: BM-DMA at 0x40a0-0x40a7, BIOS settings:
hda:DMA, hdb:pio
[    9.268286] Probing IDE interface ide0...
[    9.301139] USB Universal Host Controller Interface driver v3.0
[    9.307592] SCSI subsystem initialized
[    9.325583] libata version 2.21 loaded.
[    9.331069] Clocksource tsc unstable (delta = -127737806 ns)
[    9.333292] hda: HL-DT-ST DVDRAM GSA-T10N, ATAPI CD/DVD-ROM drive
[    9.333533] PM: Adding info for No Bus:ide0
[    9.335577] hda: selected mode 0x22
[    9.336161] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

-- 
Sergey
