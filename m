Return-Path: <linux-kernel-owner+w=401wt.eu-S1762466AbYF3NpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762466AbYF3NpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbYF3No6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:44:58 -0400
Received: from main.gmane.org ([80.91.229.2]:51019 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758043AbYF3No5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:44:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: linux-next: Tree for June 27 - build fails at
 tc6393xb_attach_irq() with randconfig build
Date: Mon, 30 Jun 2008 13:44:41 +0000 (UTC)
Message-ID: <g4ao09$be3$1@ger.gmane.org>
References: <20080627182406.a54b00c1.sfr@canb.auug.org.au>
	<48653871.9040106@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: iap-pxy-mow1.siemens.ru
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-next@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:

> Hi Stephen,
> 
> randconfig build fails on next-20080627 kernelk with CONFIG_MFD_TC6393XB
> enabled
> 
>   CC      drivers/mfd/tc6393xb.o
> drivers/mfd/tc6393xb.c: In function ‘tc6393xb_attach_irq’:
> drivers/mfd/tc6393xb.c:269: error: implicit declaration of function
> ‘set_irq_flags’ drivers/mfd/tc6393xb.c:269: error: ‘IRQF_VALID’
> undeclared (first use in this function) drivers/mfd/tc6393xb.c:269:
> error: (Each undeclared identifier is reported only once
> drivers/mfd/tc6393xb.c:269: error: for each function it appears in.)
> drivers/mfd/tc6393xb.c:269: error: ‘IRQF_PROBE’ undeclared (first use in
> this function) drivers/mfd/tc6393xb.c:272: error: ‘IRQT_FALLING’
> undeclared (first use in this function) make[2]: ***
> [drivers/mfd/tc6393xb.o] Error 1 make[1]: *** [drivers/mfd] Error 2
> make: *** [drivers] Error 2


IRQT_FALLING will be replaced with IRQ_TYPE_FALLING_EDGE.
However I've a question. set_irq_flags is arm-only thing to change the 
status IRQ_NOREQUEST, IRQ_NOPROBE etc. Most other arches (except ppc) 
don't even bother touching IRQ_NOREQUEST. Should I change tc6393xb to 
depend on ARM or make call to set_irq_flags ARM-dependant?


-- 
With best wishes
Dmitry


