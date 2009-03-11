Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbZCKOfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbZCKOfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZCKOfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:35:08 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2367 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751623AbZCKOfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:35:07 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Will Newton" <will.newton@gmail.com>
Subject: Re: [PATCH 7/7] mmc_spi: support for non-byte-aligned cards
Date: Wed, 11 Mar 2009 15:34:34 +0100
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <87a5b0800903110656x7000e0c8q23ceae7e87483bf7@mail.gmail.com>
In-Reply-To: <87a5b0800903110656x7000e0c8q23ceae7e87483bf7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903111534.34340.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

Am Mittwoch, 11. März 2009 schrieb Will Newton:
> <wolfgang.mues@auerswald.de> wrote:
> > From: Wolfgang Muees <wolfgang.mues@auerswald.de>
> >
> > o A very large subset of SD cards in the market send their
> >  responses and data non-byte-aligned. So add logic to the
> >  mmc spi driver to handle this mess.
>
> Are you sure about this?

Yes.

> Do you have any further references for this 
> or examples of cards that exhibit this problem?

Kingston. The 1 GByte SD card, and a 128 MByte microSD card. I have got some 
reports from other mmc spi users with the same problem.

The SD protocoll ist NOT byte-aligned. Messages are starting with a 
leading "0" bit. I think some chip vendors have adapted the SPI mode from SD 
mode and forgotten to do propper byte alignment. 

> Are you sure your SPI host controller is operating correctly?

Yes. My logic probe gives the same results as my spi host controller.
For some cards, you can see the bit offset is getting larger if the
controller on the SD card is getting more and more busy...

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
