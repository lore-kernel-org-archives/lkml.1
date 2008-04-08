Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYDHU61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYDHU61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYDHU6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:58:20 -0400
Received: from ozlabs.org ([203.10.76.45]:33559 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbYDHU6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:58:19 -0400
Subject: Re: compile failure in pata_sil680.c
From: Benjamin Herrenschmidt <benh@ozlabs.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <Pine.SOC.4.64.0804081640100.28938@math.ut.ee>
References: <Pine.SOC.4.64.0804081640100.28938@math.ut.ee>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 06:55:36 +1000
Message-Id: <1207688136.10388.542.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-08 at 16:44 +0300, Meelis Roos wrote:
> commit 0f436eff54f90419ac1b8accfb3e6e17c4b49a4e introduces the following 
> compile failure on ppc (not powerpc), prep subarch. Seems that 
> machine_is is only defined in the new powerpc arch.
> 
> drivers/ata/pata_sil680.c: In function 'sil680_init_chip':
> drivers/ata/pata_sil680.c:274: error: implicit declaration of function 'machine_is'
> drivers/ata/pata_sil680.c:274: error: 'cell' undeclared (first use in this function)
> drivers/ata/pata_sil680.c:274: error: (Each undeclared identifier is reported only once
> drivers/ata/pata_sil680.c:274: error: for each function it appears in.)
> make[2]: *** [drivers/ata/pata_sil680.o] Error 1

Argh. We still haven't got rid of arch/ppc...

Fix is to replace CONFIG_PPC with CONFIG_PPC_MERGE.

I'll send a patch.

Ben.


