Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbZFILZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbZFILZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbZFILZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:25:31 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40512 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbZFILZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:25:30 -0400
X-Auth-Info: j194mqbtrkDYvEEmpLyrn3xo9pEVZeMmx46ZWQsHgCQ=
Message-ID: <4A2E46A7.6020302@grandegger.com>
Date: Tue, 09 Jun 2009 13:25:27 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: net tree build warning
References: <20090609203639.96e503fe.sfr@canb.auug.org.au>
In-Reply-To: <20090609203639.96e503fe.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Stephen Rothwell wrote:
> Hi Dave,
> 
> Today's linux-next build (powerpc allyesconfig) produced these warnings:
> 
> drivers/net/can/sja1000/sja1000_of_platform.c: In function 'sja1000_ofp_probe':
> drivers/net/can/sja1000/sja1000_of_platform.c:111: warning: format '%#x' expects type 'unsigned int', but argument 4 has type 'resource_size_t'
> drivers/net/can/sja1000/sja1000_of_platform.c:111: warning: format '%#x' expects type 'unsigned int', but argument 5 has type 'resource_size_t'
> drivers/net/can/sja1000/sja1000_of_platform.c:118: warning: format '%#x' expects type 'unsigned int', but argument 4 has type 'resource_size_t'
> drivers/net/can/sja1000/sja1000_of_platform.c:118: warning: format '%#x' expects type 'unsigned int', but argument 5 has type 'resource_size_t'
> 
> Introduced by commit d1a277c584d0862dbf51991baea947ea5f2ce6bf ("can:
> sja1000: generic OF platform bus driver").

The patch below should fix the build problems (which I cannot
reproduce on my test systems).

Thanks,

Wolfgang.

-----------------------------------------------------------------------
[PATCH] can: sja1000_of_platform: fix build problems with printk format

Variables of type size_t should be printed with the format "%zx".

Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
---
 drivers/net/can/sja1000/sja1000_of_platform.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: net-next-2.6/drivers/net/can/sja1000/sja1000_of_platform.c
===================================================================
--- net-next-2.6.orig/drivers/net/can/sja1000/sja1000_of_platform.c	2009-06-09 12:45:38.000000000 +0200
+++ net-next-2.6/drivers/net/can/sja1000/sja1000_of_platform.c	2009-06-09 13:06:56.495718952 +0200
@@ -108,14 +108,14 @@
 	res_size = resource_size(&res);
 
 	if (!request_mem_region(res.start, res_size, DRV_NAME)) {
-		dev_err(&ofdev->dev, "couldn't request %#x..%#x\n",
+		dev_err(&ofdev->dev, "couldn't request %#zx..%#zx\n",
 			res.start, res.end);
 		return -EBUSY;
 	}
 
 	base = ioremap_nocache(res.start, res_size);
 	if (!base) {
-		dev_err(&ofdev->dev, "couldn't ioremap %#x..%#x\n",
+		dev_err(&ofdev->dev, "couldn't ioremap %#zx..%#zx\n",
 			res.start, res.end);
 		err = -ENOMEM;
 		goto exit_release_mem;

