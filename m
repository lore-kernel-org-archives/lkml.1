Return-Path: <linux-kernel-owner+w=401wt.eu-S1764694AbXGTOES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764694AbXGTOES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758679AbXGTOEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:04:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:50836 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762820AbXGTOEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iINWa6wzWYGAS2C9Cl2DiYaXVvDOUQDrj/RYiZpoXw2vc1lxnFE69sRC5DwhuD1PvxvRStGoTJViWxmpg8wEkxbF6o0aJPVqKoyUjBpd8epQEy4wUUUCnuGsYwoFpZaBdB5yV1EgJnoakBh3oRPCm+AkR6bUzFr7xOdREW/tHvU=
Message-ID: <94a0d4530707200704r7188ec69s151acc1e516e3ea@mail.gmail.com>
Date: Fri, 20 Jul 2007 17:04:03 +0300
From: "Felipe Contreras" <felipe.contreras@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: ata_piix broken in 2.6.22
Cc: lkml <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@redhat.com>,
       "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <46A0BB24.6050001@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <94a0d4530707200626r2b50146bs55e268033ceab4b0@mail.gmail.com>
	 <46A0BB24.6050001@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Gabriel C <nix.or.die@googlemail.com> wrote:
> Felipe Contreras wrote:
> > Hi,
>
> Hi ,
>
> >
> > Since I updated to 2.6.22 everything has been slower and I think this
> > is the reason:
> >
> > ata_piix 0000:00:1f.2: version 2.11
> > ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
> > ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 16
> > ata_piix 0000:00:1f.2: 0x1F0 IDE port busy
> > ata_piix 0000:00:1f.2: 0x170 IDE port busy
> > ata_piix 0000:00:1f.2: no available legacy port
> >
> > I tried to apply the patch d583bc18812f8da52bf25eef9cd111e5fd46a6ab,
> > but I get a similar error:
> >
> > ata_piix 0000:00:1f.2: version 2.11
> > ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
> > ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 16
> > PCI: Unable to reserve I/O region #1:8@1f0 for device 0000:00:1f.2
> > ata_piix 0000:00:1f.2: failed to request/iomap BARs for port 0 (errno=-16)
> > PCI: Unable to reserve I/O region #3:8@170 for device 0000:00:1f.2
> > ata_piix 0000:00:1f.2: failed to request/iomap BARs for port 1 (errno=-16)
> > ata_piix 0000:00:1f.2: no available native port
> >
> > I think I'm not the only one with that problem:
> > http://www.dellcommunity.com/supportforums/board/message?board.id=sw_linux&thread.id=10825
> >
> > Any hints?
> >
>
> Guessing you are using and SATA/PATA controller ?
>
> Combined mode got removed in 2.6.22 and depending on your config things will break.
>
> As example CONFIG_IDE=y  BLK_DEV_PIIX=y , ATA=y , ATA_PIIX=Y worked in <2.6.22 but won't on .22.
>
> If you want to use libata try to boot with ideX=noprobe ideY=noprobe

Oh, that's it!

I tried CONFIG_IDE=n and now ata_piix is working just fine.

Would a note in CONFIG_ATA be pertinent? Or did I miss some piece of
documentation?

Thanks.

-- 
Felipe Contreras
