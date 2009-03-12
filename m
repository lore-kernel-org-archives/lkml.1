Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZCLISz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZCLISz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbZCLISj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:18:39 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2782 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752497AbZCLISi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:18:38 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 5/7] mmc_spi: allow higher timeouts for SPI mode
Date: Thu, 12 Mar 2009 09:16:27 +0100
User-Agent: KMail/1.9.10
Cc: "Matt Fleming" <matt@console-pimps.org>,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200903111317.42696.david-b@pacbell.net>
In-Reply-To: <200903111317.42696.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903120916.27797.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Am Mittwoch, 11. März 2009 schrieb David Brownell:
> I think you're confused.  A *delay() call will busy-wait.
> But a *sleep() call like msleep() will schedule.

Yes. You are right. I was confused. Sorry for that.

> (These speed concerns apply primarily to patch #6, not
> this one ...)

But I think the consequences of patch #6 are over-estimated. I have not noted 
a slowdown in filesystem I/O. Most responses are coming in while the loop is 
in busy-waiting. And for most embedded systems, it _is_ important to don't 
allow long periods of busy-waiting.

There are other problems which are more notable: I have found that SDHC cards 
(with FAT32, clustersize = 4 KByte) are much SLOWER than the older SD cards 
(with FAT16, clustersize = 16-32 KByte). I will do some investigation here.

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
