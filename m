Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYDNEzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYDNEzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 00:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYDNEyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 00:54:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39466
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbYDNEyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 00:54:51 -0400
Date: Sun, 13 Apr 2008 21:54:52 -0700 (PDT)
Message-Id: <20080413.215452.31407494.davem@davemloft.net>
To: vda.linux@googlemail.com
Cc: chas@cmf.nrl.navy.mil, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/atm/horizon.c: stop inlining largish static
 functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <200804081221.42465.vda.linux@googlemail.com>
References: <200804081221.42465.vda.linux@googlemail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 8 Apr 2008 12:21:42 +0200

> drivers/atm/horizon.c has unusually large number
> of static inline functions - 36.
> 
> I looked through them. Most of them seems to be small enough,
> but a few are big, others are using udelay or busy loop,
> and as such are better not be inlined.
> 
> This patch removes "inline" from these static functions
> (regardless of number of callsites - gcc nowadays auto-inlines
> statics with one callsite).
> 
> Size difference for 32bit x86:
>    text    data     bss     dec     hex filename
>    8201     180       6    8387    20c3 linux-2.6-ALLYES/drivers/atm/horizon.o
>    7840     180       6    8026    1f5a linux-2.6.inline-ALLYES/drivers/atm/horizon.o
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Applied to net-2.6.26, thanks Denys.
