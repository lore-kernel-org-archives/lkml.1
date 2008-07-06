Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbYGFVuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbYGFVuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbYGFVun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:50:43 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:51836 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbYGFVum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:50:42 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: pata_it821x completely broken
Date: Sun, 6 Jul 2008 23:50:33 +0200
User-Agent: KMail/1.9.9
Cc: alan@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <200807042153.56644.linux@rainbow-software.org> <200807051242.00545.linux@rainbow-software.org> <20080706203716.2c5bdcc5@lxorguk.ukuu.org.uk>
In-Reply-To: <20080706203716.2c5bdcc5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807062350.35650.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 July 2008 21:37:16 Alan Cox wrote:
> > When I force the pass-through mode, it oopses (haven't captured it yet as
> > it's too long). Forcing pass-through mode works fine with UDMA-capable
> > drives:
>
> Couldn't reproduce that yet but the HPA case should be fixed by the
> following patch:

Thanks, it does not complain about HPA anymore. However, there are some error 
messages left. I thought that they were connected with the HPA, but obviously 
they aren't:

sd 2:0:0:0: [sdb] Synchronizing SCSI cache
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
ata3.00: limiting speed to UDMA/133:PIO6
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: limiting speed to UDMA/33:PIO6
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3: soft resetting link
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:01:01:00:00/00:00:00:00:00/00 Emask 0x1 (device error)
ata3.00: status: { DRDY }
ata3.00: configured for DMA
ata3: EH complete
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
sd 2:0:0:0: [sdb] Sense Key : 0xb [current] [descriptor]
sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Restarting system.
machine restart



>
> pata_it821x: With newer firmware we see HPA flags
>
> From: Alan Cox <alan@redhat.com>
>
> We don't want HPA flags set at this point as we don't allow the issuing of
> HPA operations via the 'smart' firmware interface. It could be 1.7 firmware
> supports this but for the moment the blunt hammer is appealing (one reason
> being right now we don't actually know how to peek at the firmware rev!)
> ---
>
>  drivers/ata/pata_it821x.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
>
> diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
> index e108169..977e5f8 100644
> --- a/drivers/ata/pata_it821x.c
> +++ b/drivers/ata/pata_it821x.c
> @@ -80,7 +80,7 @@
>
>
>  #define DRV_NAME "pata_it821x"
> -#define DRV_VERSION "0.3.8"
> +#define DRV_VERSION "0.3.9"
>
>  struct it821x_dev
>  {
> @@ -519,6 +519,8 @@ static void it821x_dev_config(struct ata_device *adev)
>  	/* This is a controller firmware triggered funny, don't
>  	   report the drive faulty! */
>  	adev->horkage &= ~ATA_HORKAGE_DIAGNOSTIC;
> +	/* No HPA in 'smart' mode */
> +	adev->horkage |= ATA_HORKAGE_BROKEN_HPA;
>  }
>
>  /**
> @@ -546,7 +548,9 @@ static int it821x_ident_hack(struct ata_port *ap)
>  			adev->id[76] = 0;		/* No NCQ/AN etc */
>  		}
>  	}
> -	return ata_cable_unknown(ap);
> +	/* This is actually meaningless, but reporting 80 wire avoids
> +	   warnings about cable types */
> +	return ata_cable_80wire(ap);
>  }



-- 
Ondrej Zary
