Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbZJJRz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbZJJRz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 13:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761899AbZJJRzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 13:55:24 -0400
Received: from web84205.mail.re3.yahoo.com ([216.252.111.5]:34465 "HELO
	web84205.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762014AbZJJRzW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 13:55:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=s3n5bPRgmmyP3LiTFxImO/FogLxSLvU3hzxl1rrMtAEXF6usPKsdn/2GlKrYgdsSyzQmWYfw6qS1appbUg5Wj/+fSWrGSMhFUAO2SbSsvXTbclP7VCFdZ/Wn/hOz61rzeCuTHp12qtq3h+b4htE5eXbnU7nBDsTPxLB9Jl40LdY=;
Message-ID: <538060.73944.qm@web84205.mail.re3.yahoo.com>
X-YMail-OSG: lSo.X_kVM1no48TXOE3h.gyOViegZOa_7Qi82HGKRoaLcHbAr3j1Gui6G4oXYdWw3gNEo3Ma.tEiUY8.Y9GKo9vJr1utsOjO_2JKfL.frlN8Oqk7ZYKM7mgI3sRH6aQtwu.GJFo9RTnN3nCE_U1XpxXVuTPCRyef3vL2rSTGl6Zktj4UUf7V5.jOEiuJLCe5yxF24KUF7rsJbSXPOI2IGKQOX68Fb1yPt7m.RUCb5HLlH0a8N9lLxigxzFXm136pag.MhzVPbpOlgI2dLAxOosRcDlcn2rIjBIGCidhTfW6pHe.sCnRzDxhrroSsrK1W6Vz5WGCoJuBKJNofGXCiugaImq0lw4gh.QElgDQBNR8Uhoyco6Ucc_WhNeU0uNXb7lTKiYGuM0_B5XrS9Ah2EMsYyQ--
X-Mailer: YahooMailClassic/7.0.14 YahooMailWebService/0.7.347.3
Date: Sat, 10 Oct 2009 10:54:45 -0700 (PDT)
From: - <d.stussy@yahoo.com>
Subject: Re: [PATCH 0/2] two ide fixes for -rc4
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Joao Ramos <joao.ramos@inov.pt>,
       David Fries <david@fries.net>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200910070246.05283.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This latest patch (modifying only the SIS 5513 driver) WORKS FOR ME.  :-)
   - D. Stussy.

--- On Tue, 10/6/09, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> ...
> --- a/drivers/ide/sis5513.c
> +++ b/drivers/ide/sis5513.c
> @@ -281,11 +281,13 @@ static void config_drive_art_rwp(ide_dri
>  
>      pci_read_config_byte(dev, 0x4b, &reg4bh);
>  
> +    rw_prefetch = reg4bh & ~(0x11 << drive->dn);
> +
>      if (drive->media == ide_disk)
> -        rw_prefetch = 0x11 << drive->dn;
> +        rw_prefetch |= 0x11 << drive->dn;
>  
> -    if ((reg4bh & (0x11 << drive->dn)) != rw_prefetch)
> -        pci_write_config_byte(dev, 0x4b, reg4bh|rw_prefetch);
> +    if (reg4bh != rw_prefetch)
> +        pci_write_config_byte(dev, 0x4b, rw_prefetch);
>  }
>  
>  static void sis_set_pio_mode(ide_drive_t *drive, const u8 pio)
> 
