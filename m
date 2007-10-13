Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbXJMEfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbXJMEfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 00:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXJMEfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 00:35:44 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:37529 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbXJMEfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 00:35:43 -0400
Message-ID: <47104AFF.7000501@linux.vnet.ibm.com>
Date: Sat, 13 Oct 2007 10:05:11 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1 - Build failure on rgmii
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The build fails with following message

CC drivers/net/ibm_newemac/zmii.o
CC drivers/net/ibm_newemac/rgmii.o
drivers/net/ibm_newemac/rgmii.c: In function ‘rgmii_probe’:
drivers/net/ibm_newemac/rgmii.c:254: error: implicit declaration of
function ‘device_is_compatible’
make[3]: *** [drivers/net/ibm_newemac/rgmii.o] Error 1
make[2]: *** [drivers/net/ibm_newemac] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

The function device_is_compatible does not exist, and seems to called
instead of
of_device_compatible. This patch replace the function.

Signed-off-by : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---

--- linux-2.6.23/drivers/net/ibm_newemac/rgmii.c        2007-10-12 12:10:48.000000000 +0530
+++ linux-2.6.23/drivers/net/ibm_newemac/~rgmii.c       2007-10-12 14:37:21.000000000 +0530
@@ -251,7 +251,7 @@ static int __devinit rgmii_probe(struct 
        }
 
        /* Check for RGMII type */
-       if (device_is_compatible(ofdev->node, "ibm,rgmii-axon"))
+       if (of_device_is_compatible(ofdev->node, "ibm,rgmii-axon"))
                dev->type = RGMII_AXON;
        else
                dev->type = RGMII_STANDARD;


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

