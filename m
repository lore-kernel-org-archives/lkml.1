Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547Ab0ANTsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab0ANTsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 14:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882Ab0ANTsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 14:48:54 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:39769 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab0ANTsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:48:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pQGgKBVwJrWZ6z98fZPsygkkhNxoQ1/zS5BVaCb2C+WE9pKiKC5ox9oAZ3QrlhnSUw
         GmOo40f31pSPj403Rhcz5bQ+IlKATjjL8BFQ5CWoEInszHniU48Rj4CgXW+5b6aJOxS1
         yC6FPLpyp5D49iQypwjeAO/FMNUqhAf9PfgoA=
Message-ID: <4B4F762A.20605@gmail.com>
Date: Thu, 14 Jan 2010 20:53:14 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Marc Zyngier <maz@misterjones.org>
CC: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sparc: leds_resource.end assigned to itself in clock_board_probe()
References: <4B4F4C9B.9040202@gmail.com> <20100114183054.0b53c351@taxman.wild-wind.fr.eu.org>
In-Reply-To: <20100114183054.0b53c351@taxman.wild-wind.fr.eu.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be a 1 byte region.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
>> Is there any reason to assign this to itself?

>> @@ -99,7 +99,6 @@ static int __devinit clock_board_probe(struct
>> of_device *op, 
>>  	p->leds_resource.start = (unsigned long)
>>  		(p->clock_regs + CLOCK_CTRL);
>> -	p->leds_resource.end = p->leds_resource.end;
> 
> I have the feeling that the right fix is to have:
> 
> 	p->leds_resource.end = p->leds_resource.start;
> 
> hence describing a 1 byte region.

diff --git a/arch/sparc/kernel/central.c b/arch/sparc/kernel/central.c
index f3b5466..4589ca3 100644
--- a/arch/sparc/kernel/central.c
+++ b/arch/sparc/kernel/central.c
@@ -99,7 +99,7 @@ static int __devinit clock_board_probe(struct of_device *op,
 
 	p->leds_resource.start = (unsigned long)
 		(p->clock_regs + CLOCK_CTRL);
-	p->leds_resource.end = p->leds_resource.end;
+	p->leds_resource.end = p->leds_resource.start;
 	p->leds_resource.name = "leds";
 
 	p->leds_pdev.name = "sunfire-clockboard-leds";
@@ -194,7 +194,7 @@ static int __devinit fhc_probe(struct of_device *op,
 	if (!p->central) {
 		p->leds_resource.start = (unsigned long)
 			(p->pregs + FHC_PREGS_CTRL);
-		p->leds_resource.end = p->leds_resource.end;
+		p->leds_resource.end = p->leds_resource.start;
 		p->leds_resource.name = "leds";
 
 		p->leds_pdev.name = "sunfire-fhc-leds";
