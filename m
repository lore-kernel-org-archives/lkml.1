Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZG0VNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZG0VNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbZG0VNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:13:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896AbZG0VNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:13:07 -0400
Date: Mon, 27 Jul 2009 14:10:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <mike@compulab.co.il>
Cc: joe@perches.com, wim@iguana.be, linux-kernel@vger.kernel.org,
       denis@compulab.co.il, mike@compulab.co.il, pazke@centrinvest.ru
Subject: Re: [PATCH v2] add SBC-FITPC2 watchdog driver
Message-Id: <20090727141024.5ea28817.akpm@linux-foundation.org>
In-Reply-To: <4A6594C9.4010403@compulab.co.il>
References: <4A6594C9.4010403@compulab.co.il>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 13:13:29 +0300
Mike Rapoport <mike@compulab.co.il> wrote:

> > From: Denis Turischev <denis@compulab.co.il>
> 
> This patch adds support for watchdog found on SBC-FITPC2 board.
> 
> +/*
> + * Watchdog driver for SBC-FITPC2 board
> + *
> + * Author: Denis Turischev <denis@compulab.co.il>
> + *
> + * Adapted from the IXP2000 watchdog driver by Deepak Saxena.
> + *
> + * This file is licensed under  the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME " WATCHDOG: " fmt
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/miscdevice.h>
> +#include <linux/watchdog.h>
> +#include <linux/ioport.h>
> +#include <linux/delay.h>
> +#include <linux/notifier.h>
> +#include <linux/fs.h>
> +#include <linux/reboot.h>
> +#include <linux/init.h>
> +#include <linux/moduleparam.h>
> +#include <linux/dmi.h>
> +
> +#include <linux/io.h>
> +#include <linux/uaccess.h>
> +#include <asm/system.h>
> +
> +static int nowayout = WATCHDOG_NOWAYOUT;
> +static unsigned int margin = 60;	/* (secs) Default is 1 minute */
> +static unsigned long wdt_status;
> +static spinlock_t wdt_lock;

You forgot to initialise the spinlock.

--- a/drivers/watchdog/sbc_fitpc2_wdt.c~watchdog-add-sbc-fitpc2-watchdog-driver-fix
+++ a/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -32,7 +32,7 @@
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int margin = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
-static spinlock_t wdt_lock;
+static DEFINE_SPINLOCK(wdt_lock);
 
 #define	WDT_IN_USE		0
 #define	WDT_OK_TO_CLOSE		1
_

