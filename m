Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbXHCKli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbXHCKli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 06:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759709AbXHCKl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 06:41:28 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:60014 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759639AbXHCKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 06:41:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=UaZ2KGu8oeVpArlc8qhmTlvTEXs1lR2b7ibWEYlpcsQZkbyS98PdxBhuaLxjbH2Ohpf1lBmcZTKKHsouwoub0yVlGDEvlxfCuoGKk8CN9JrBKLn6cn3Kf0Ouc519BnOQcQGkSk75CRXPR98B8Lnd8+NbCsK0B0ZokH/P3FxVdSw=
Message-ID: <46B30651.9030505@gmail.com>
Date: Fri, 03 Aug 2007 19:41:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: Mark Lord <lkml@rtr.ca>, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ICH8 CF timeout (regression)...
References: <6278d2220708020348k26ac2293v648442f2281eca70@mail.gmail.com>	 <46B20D6B.1060506@gmail.com>	 <6278d2220708021411q17cdc151p79922e5dab74add4@mail.gmail.com>	 <46B25DE1.4050105@rtr.ca> <6278d2220708030322h2c779fa3o1e2e2d9c83ff62e8@mail.gmail.com>
In-Reply-To: <6278d2220708030322h2c779fa3o1e2e2d9c83ff62e8@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------040808040602010706050405"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040808040602010706050405
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Daniel J Blueman wrote:
> The ICH8 south-bridge I have is the mobile variant and does come
> equipped with native parallel IDE - see page 447:
> http://download.intel.com/design/chipsets/datashts/31305603.pdf . I do
> see 35MB/s with DMA enabled from my CF on the 1 in 15 times the
> libata-kernel does work.
> 
> I can dump off and decode the configuration registers for the timing
> and bus master registers in the working and non-working libata cases,
> and the legacy ATA working case and see what's different.

Does the attached patch change anything?

-- 
tejun

--------------040808040602010706050405
Content-Type: text/x-patch;
 name="ich8-map-01b-update.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ich8-map-01b-update.patch"

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index ad07086..47a344b 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -436,7 +436,7 @@ static const struct piix_map_db ich8_map_db = {
 		/* PM   PS   SM   SS       MAP */
 		{  P0,  P2,  P1,  P3 }, /* 00b (hardwired when in AHCI) */
 		{  RV,  RV,  RV,  RV },
-		{  IDE,  IDE,  NA,  NA }, /* 10b (IDE mode) */
+		{  P0,  P2, IDE, IDE }, /* 10b (IDE mode) */
 		{  RV,  RV,  RV,  RV },
 	},
 };

--------------040808040602010706050405--
