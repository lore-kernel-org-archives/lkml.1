Return-Path: <linux-kernel-owner+w=401wt.eu-S932485AbXGMNij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbXGMNij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbXGMNib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:38:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58260 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbXGMNia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:38:30 -0400
Subject: Re: [Resend][Patch] drivers/mtd/maps/tqm8xxl.c: Do some cleanups
From: David Woodhouse <dwmw2@infradead.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, kirk@hpc.ee.ntu.edu.tw,
       akpm@osdl.org, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>, ralf@linux-mips.org
In-Reply-To: <20070713131458.GA1997@localhost.localdomain>
References: <20070712150135.GA4102@localhost.localdomain>
	 <1184256718.32199.111.camel@weaponx.rchland.ibm.com>
	 <20070713034822.GA2370@localhost.localdomain>
	 <1184320602.2785.18.camel@shinybook.infradead.org>
	 <20070713131458.GA1997@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 14:38:03 +0100
Message-Id: <1184333884.8809.5.camel@hades.cambridge.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 21:14 +0800, WANG Cong wrote:
> On Fri, Jul 13, 2007 at 10:56:42AM +0100, David Woodhouse wrote:
> >On Fri, 2007-07-13 at 11:48 +0800, WANG Cong wrote:
> >>                 if(map_banks[idx] == NULL) {
> >>                         ret = -ENOMEM;
> >> -                       /* FIXME: What if some MTD devices were probed already? */
> >> +                       /* FIXME: What if some MTD devices were probed
> >> +                       already? */
> >>                         goto error_mem;
> >>                 } 
> >
> >
> >That's just horrid. Leave it as it was.
> >
> 
> Sorry, I can't fully understand you. You mean only the above change is horrid or
> the entire patch?

Just the above change. See Linus' comments about strict limits on 80
columns being a Nazi dream.

> I have some questions about mtd/maps drivers. Even when I use `make allyesconfig`,
> I still can't compile some drivers. I should add the corresponding CONFIGs manually.
> Why this? And I still got some errors and warnings, such as:
> 
> drivers/mtd/maps/pmcmsp-flash.c:40:22: error: msp_prom.h: No such file or directory
> drivers/mtd/maps/pmcmsp-flash.c:41:22: error: msp_regs.h: No such file or directory
> drivers/mtd/maps/pmcmsp-flash.c: In function 'init_msp_flash':
> drivers/mtd/maps/pmcmsp-flash.c:62: error: 'DEV_ID_REG' undeclared (first use in this function)
> drivers/mtd/maps/pmcmsp-flash.c:62: error: (Each undeclared identifier is reported only once
> drivers/mtd/maps/pmcmsp-flash.c:62: error: for each function it appears in.)
> drivers/mtd/maps/pmcmsp-flash.c:62: error: 'DEV_ID_SINGLE_PC' undeclared (first use in this function)
> drivers/mtd/maps/pmcmsp-flash.c:63: error: 'ELB_1PC_EN_REG' undeclared (first use in this function)
> drivers/mtd/maps/pmcmsp-flash.c:63: error: 'SINGLE_PCCARD' undeclared (first use in this function)
> 
> Did I miss something?

I think that map driver should probably depend on CONFIG_PMC_MSP. Ralf?

-- 
dwmw2

