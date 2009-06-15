Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZFOIgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZFOIgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZFOIgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:36:22 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:17571 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750767AbZFOIgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:36:21 -0400
From: Wolfgang =?utf-8?q?M=C3=BCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc_spi: fail gracefully if host or card do not support the switch command
Date: Mon, 15 Jun 2009 10:36:05 +0200
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200906111713.27504.wolfgang.mues@auerswald.de> <20090613130829.49216355@mjolnir.ossman.eu>
In-Reply-To: <20090613130829.49216355@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906151036.05884.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pierre,

Am Samstag, 13. Juni 2009 schrieb Pierre Ossman:
> > The switch command (typically speed switching from 25 to 50 MHz clock)
> > can be rejected by _both_ the host controller/driver and by the card.
> > Elder revisions of the SD card do not support speed switching.
> > Fail gracefully if the reject is comming from the card.

> Have you ever seen this in practice?

Yes, I have. An old 1 GByte SD card.

> For SD there are several checks 
> before the switch command is actually issued.

But there are two cases not covered by these checks:

a) the switch command is supported, but the card is not capable of switching 
to 50 MHz.

b) the card rejects the switch command in SPI mode, because it is not 
mandatory here.

So yes, the checks can be improved. But only extending the error codes was a 
simple, fast and minimal solution.

regards

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
