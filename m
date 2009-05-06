Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbZEFJrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbZEFJrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZEFJqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:46:51 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:4275 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752803AbZEFJqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:46:50 -0400
From: Wolfgang =?utf-8?q?M=C3=BCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer
Date: Wed, 6 May 2009 11:45:30 +0200
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200904081155.53173.wolfgang.mues@auerswald.de> <200904141627.26276.wolfgang.mues@auerswald.de> <20090428215730.24fa60c5@mjolnir.ossman.eu>
In-Reply-To: <20090428215730.24fa60c5@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905061145.30698.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre,

Am Dienstag, 28. April 2009 schrieb Pierre Ossman:
> You're wrong in that EINVAL should not be sent for any kind of runtime
> hardware errors like that. But I might have missed some instances during
> reviews, so there might be drivers that give that error message for
> things they shouldn't.

I checked the drivers sourcecode and found that most drivers are using EINVAL 
for non-recoverable parameter errors.

The only driver which uses EINVAL for errors which might result from 
transmission failures is mmc_spi.

So I think it would be OK to use another error code in mmc_spi for these 
cases:

 * EILSEQ       Basic format problem with the received or sent data
 *              (e.g. CRC check failed, incorrect opcode in response
 *              or bad end bit)

Would you accept a patch to report another error code in mmc_spi?

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
