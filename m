Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbYDBLVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbYDBLVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYDBLVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:21:31 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4200 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYDBLVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:21:30 -0400
Date: Wed, 2 Apr 2008 13:20:07 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Keep track of original clocksource frequency
In-Reply-To: <1205878279.28128.114.camel@localhost>
Message-ID: <Pine.LNX.4.64.0804021314400.26791@localhost.localdomain>
References: <1205878279.28128.114.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 18 Mar 2008, john stultz wrote:

> @@ -63,6 +64,7 @@ struct clocksource {
>  	cycle_t (*read)(void);
>  	cycle_t mask;
>  	u32 mult;
> +	s32 mult_orig;
>  	u32 shift;
>  	unsigned long flags;
>  	cycle_t (*vread)(void);

This is wrong, with HZ=100 the jiffies clock multiplier suddenly becomes 
negative and later the raw interval underflows.

bye, Roman


Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 include/linux/clocksource.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/clocksource.h
===================================================================
--- linux-2.6.orig/include/linux/clocksource.h
+++ linux-2.6/include/linux/clocksource.h
@@ -64,7 +64,7 @@ struct clocksource {
 	cycle_t (*read)(void);
 	cycle_t mask;
 	u32 mult;
-	s32 mult_orig;
+	u32 mult_orig;
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
