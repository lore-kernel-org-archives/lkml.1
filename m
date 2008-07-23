Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYGWUR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYGWUR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYGWURt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:17:49 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1943 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754839AbYGWURs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:17:48 -0400
Message-ID: <488791DB.5090204@myri.com>
Date: Wed, 23 Jul 2008 22:17:31 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression: myri10ge driver in 2.6.26
References: <20080722150438.GK4359@ics.muni.cz> <48865B04.6030707@myri.com> <488664A0.3040407@myri.com> <20080723080638.GL4359@ics.muni.cz> <4886E932.1010206@myri.com> <20080723125426.GN4359@ics.muni.cz>
In-Reply-To: <20080723125426.GN4359@ics.muni.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> Hello,
>
> On Wed, Jul 23, 2008 at 10:17:54AM +0200, Brice Goglin wrote:
>   
>> Thanks for testing, I just sent the patch to stable@
>>     
>
> it seems, I got another problem with the driver from 2.6.26:
>   

Does this help ?

--- linux.old/drivers/net/myri10ge/myri10ge.c	2008-07-23 17:13:20.000000000 +0200
+++ linux/drivers/net/myri10ge/myri10ge.c	2008-07-23 22:07:58.000000000 +0200
@@ -3126,6 +3126,8 @@ static int myri10ge_probe(struct pci_dev
 
 	mgp = netdev_priv(netdev);
 	mgp->dev = netdev;
+	mgp->ss.mgp = mgp;
+	mgp->ss.dev = mgp->dev;
 	netif_napi_add(netdev, &mgp->ss.napi, myri10ge_poll, myri10ge_napi_weight);
 	mgp->pdev = pdev;
 	mgp->csum_flag = MXGEFW_FLAGS_CKSUM;


