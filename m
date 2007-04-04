Return-Path: <linux-kernel-owner+w=401wt.eu-S1751357AbXDDVvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbXDDVvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXDDVvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:51:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54473 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbXDDVvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:51:18 -0400
Date: Wed, 4 Apr 2007 14:51:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, Kai Svahn <kai.svahn@nokia.com>
Subject: Re: [PATCH 63/90] ARM: OMAP: Merge PM code from N800 tree
Message-Id: <20070404145126.e7dc3f94.randy.dunlap@oracle.com>
In-Reply-To: <11757101391215-git-send-email-tony@atomide.com>
References: <11757099691323-git-send-email-tony@atomide.com>
	<11757100713004-git-send-email-tony@atomide.com>
	<11757100752021-git-send-email-tony@atomide.com>
	<11757100781275-git-send-email-tony@atomide.com>
	<11757100811771-git-send-email-tony@atomide.com>
	<11757100821353-git-send-email-tony@atomide.com>
	<11757100853841-git-send-email-tony@atomide.com>
	<1175710087578-git-send-email-tony@atomide.com>
	<11757100911247-git-send-email-tony@atomide.com>
	<1175710093864-git-send-email-tony@atomide.com>
	<11757100952384-git-send-email-tony@atomide.com>
	<11757100982726-g!
 it-send-email-tony@atomide.com>
	<11757101012787-git-send-email-tony@atomide.com>
	<1175710103340-git-send-email-tony@atomide.com>
	<11757101072553-git-send-email-tony@atomide.com>
	<11757101101180-git-send-email-tony@atomide.com>
	<11757101123620-git-send-email-tony@atomide.com>
	<11757101141643-git-send-email-tony@atomide.com>
	<11757101391215-git-send-email-tony@atomide.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2007 14:05:42 -0400 Tony Lindgren wrote:

> From: Kai Svahn <kai.svahn@nokia.com>
> 
> This patch merges omap2 PM code from N800 tree.
> 
> Patch adds support for sleep while idle for omap2
> and handy serial console debbugging code. It also
> moves code from pm-domain.c to pm.c.
> 
> This code can be used as a base for developing
> power management for all omap24xx boards.
> 
> ---
>  arch/arm/mach-omap2/Makefile    |    2 +-
>  arch/arm/mach-omap2/pm-domain.c |  299 ------------
>  arch/arm/mach-omap2/pm.c        |  969 ++++++++++++++++++++++++++++-----------
>  arch/arm/mach-omap2/sleep.S     |   23 +-
>  include/asm-arm/arch-omap/pm.h  |   66 +---
>  5 files changed, 719 insertions(+), 640 deletions(-)

> diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
> index d7eee99..1034eb9 100644
> --- a/arch/arm/mach-omap2/pm.c
> +++ b/arch/arm/mach-omap2/pm.c
> @@ -6,6 +6,16 @@
>   * Copyright (C) 2006 Nokia Corporation
>   * Tony Lindgren <tony@atomide.com>
>   *
> + * Fixed suspend-resume/dynamic-idle to get OMAP to retention
> + * Amit Kucheria <amit.kucheria@nokia.com>
> + * Igor Stoppa <igor.stoppa@nokia.com>
> + *
> + * Fixed MPU sleep to get ARM idle
> + * Igor Stoppa <igor.stoppa@nokia.com>
> + *
> + * Fixed MPU sleep some more
> + * Juha Yrjola
> + *

Changelog goes in the SCM metadata, not source files.


> +extern void omap2_gpio_prepare_for_retention(void);
> +extern void omap2_gpio_resume_after_retention(void);

externs in header files, please.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
