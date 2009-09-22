Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbZIVPdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbZIVPdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbZIVPdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:33:23 -0400
Received: from fifo99.com ([67.223.236.141]:60400 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbZIVPdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:33:22 -0400
Subject: Re: [PATCH 1/2] Add COH 901 318 DMA block driver
From: Daniel Walker <dwalker@fifo99.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1253630313-20225-1-git-send-email-linus.walleij@stericsson.com>
References: <1253630313-20225-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 08:33:22 -0700
Message-Id: <1253633602.22454.0.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 16:38 +0200, Linus Walleij wrote:
> +       val &= ~COH901318_CX_CFG_CH_ENABLE;
> +       writel(val, virtbase + COH901318_CX_CFG +
> +              COH901318_CX_CFG_SPACING * channel);
> +
> +       writel(val, virtbase + COH901318_CX_CFG +
> +              COH901318_CX_CFG_SPACING * channel);
> +       wmb();
> +
> +       /* Spin-wait for it to actually go inactive */
> +       while (readl(virtbase + COH901318_CX_STAT+COH901318_CX_STAT_SPACING *
> +                    channel) & COH901318_CX_STAT_ACTIVE) {}

You might want to add a cpu_relax() here ..

Daniel



