Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132Ab0ASPL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0ASPL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 10:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112Ab0ASPL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 10:11:56 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:24760 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0ASPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 10:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=xxo4i2hPHfCwsgIRppeHG2wvEYGS4ODHzkYiC58kVw3hPZPRu4/Znzxc3B9om9KQyz
         iweZBSTvk6Pk5Zqokl8zzUaf2lUD7sXBbaXm3DyqETO3UntKWsrk9eDD2QA+2yEHMq2G
         4zoPrwolXneTigXyE4FrsUupUMIh0gILV7U4U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 46/64] ide: add drive->pio_mode field
Date: Tue, 19 Jan 2010 16:09:46 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118172028.14623.55296.sendpatchset@localhost> <4B54B656.2090307@ru.mvista.com>
In-Reply-To: <4B54B656.2090307@ru.mvista.com>
MIME-Version: 1.0
Message-Id: <201001191609.46434.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010 08:28:22 pm Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: add drive->pio_mode field
> >
> > Add pio_mode field to ide_drive_t matching pio_mode field used in
> > struct ata_device.
> >
> > The validity of the field is restricted to ->set_pio_mode method
> > only currently in IDE subsystem.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/ide-devsets.c   |    2 ++
> >  drivers/ide/ide-probe.c     |    2 ++
> >  drivers/ide/ide-xfer-mode.c |    3 +++
> >  include/linux/ide.h         |    1 +
> >  4 files changed, 8 insertions(+)
> >
> > Index: b/drivers/ide/ide-devsets.c
> > ===================================================================
> > --- a/drivers/ide/ide-devsets.c
> > +++ b/drivers/ide/ide-devsets.c
> > @@ -105,6 +105,8 @@ static int set_pio_mode(ide_drive_t *dri
> >  		return -ENOSYS;
> >  
> >  	if (set_pio_mode_abuse(drive->hwif, arg)) {
> > +		drive->pio_mode = arg + XFER_PIO_0;
> > +
> >   
> 
>    Er, didn't understand this... these 'arg' values are not really PIO 
> modes, no?

In the usual case they are and a few 'special' ->set_pio_mode implementations
will extract the desired 'arg' value just fine by doing '- XFER_PIO_0'..

--
Bartlomiej Zolnierkiewicz
