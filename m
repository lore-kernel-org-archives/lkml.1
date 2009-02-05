Return-Path: <linux-kernel-owner+w=401wt.eu-S1759618AbZBEUSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618AbZBEUSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZBEUSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:18:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbZBEUSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:18:35 -0500
Date: Thu, 5 Feb 2009 12:10:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Pihet <jpihet@mvista.com>
Cc: tony@atomide.com, ext-adrian.hunter@nokia.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       jarkko.lavinen@nokia.com, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP: MMC: recover from transfer failures - Resend
Message-Id: <20090205121045.4022c319.akpm@linux-foundation.org>
In-Reply-To: <200902031505.58697.jpihet@mvista.com>
References: <20081207213617.10456.43951.stgit@localhost>
	<200902020946.16508.jpihet@mvista.com>
	<20090202190503.GT7215@atomide.com>
	<200902031505.58697.jpihet@mvista.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 15:05:58 +0100
Jean Pihet <jpihet@mvista.com> wrote:

> +	while (OMAP_HSMMC_READ(host->base,
> + 			SYSCTL) & SRD)
> + 		;

Is a __raw_readl() sufficient to prevent the cpu from burning up here,
or should we add cpu_relax()?

An infinite loop which assumes the hardware is perfect is always a
worry.  But I see the driver already does that, so we're no worse off..

