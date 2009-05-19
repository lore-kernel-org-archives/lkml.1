Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZESJQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZESJQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbZESJQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:16:39 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:10644 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750831AbZESJQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:16:39 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Matt Fleming" <matt@console-pimps.org>
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer - rewritten
Date: Tue, 19 May 2009 11:16:27 +0200
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       "Nicolas Ferre" <nicolas.ferre@atmel.com>
References: <20090519084102.GA28564@console-pimps.org>
In-Reply-To: <20090519084102.GA28564@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905191116.27361.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

Am Dienstag, 19. Mai 2009 schrieb Matt Fleming:
> Oh, wow. I didn't pick up on the fact that you were artificially
> generating errors on the bus.

I have started with observing random errors in a batch of 20 pre-production 
devices. There were about 1 error in 10 seconds of transfer due to an non-
optimal GND area design. Remember that for 25 MHz SPI clock, you only have
20ns from the start of the clock pulse into the SD card, and out of the
data line of the SD card and into the controller. This is fast - and induced 
EMP pulses of say 5 ns will be able to produce random transmission errors. 
And you can not apply any filtering to the data lines at 25 MHz - so you need 
some sort of fault tolerance in the software.

After that observation, I started to test these devices with an ESD pulse 
tester to test the software retry logic.

best regards
 
i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
