Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZALKut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZALKut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZALKul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:50:41 -0500
Received: from mx1.auerswald.de ([212.185.163.234]:2682 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752247AbZALKuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:50:40 -0500
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Matt Fleming" <matt@console-pimps.org>
Subject: Re: [PATCH] Fixes and enhancements for the MMC SPI driver
Date: Mon, 12 Jan 2009 11:50:32 +0100
User-Agent: KMail/1.9.10
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, "Pierre Ossman" <drzeus@drzeus.cx>
References: <20090108092407.GA6108@console-pimps.org>
In-Reply-To: <20090108092407.GA6108@console-pimps.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901121150.32714.wolfgang.mues@auerswald.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

I think I should explain a little bit more the situation with the current 
implementation of the MMC SPI driver...

The SPI mode is not used widely to drive SD cards. Most SD capable devices are 
using 1 bit or 4 bit SD mode. SPI mode is only used by some embedded devices 
which have no native SD host controller.

So, in practice, most of the available SD cards have bugs in the SPI mode. 
These bugs are unlikely to fix by the SD card vendors because SPI mode is not 
in focus. In general, Sandisk has the best SPI mode.

The current MMC SPI driver without my patch was able to work with only ONE of 
my cards (a new microSD card from Sandisk). All other cards failed. Common 
causes of failure are implementation bugs in the SD card: missing response 
timing or timeouts.

With my patch applied, all of my available cards (with the exception of one 
card which fails because of a bit offset error in reading blocks) are 
working. For the bit-offset error, I have found no easy and performant 
solution. (You have to bitshift the whole datastream).

So, essential, all of my patch is for common SPI bugs in SD cards - not only 
the timeout adjust you comlpained about.

So, my patch changes the status of the MMC SPI driver from "don't work for the 
majority of cards" to "work for the majority of cards".

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
