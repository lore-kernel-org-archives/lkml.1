Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788Ab0A1IU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab0A1IU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 03:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935Ab0A1IU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 03:20:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548Ab0A1IUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 03:20:55 -0500
Date: Thu, 28 Jan 2010 00:19:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
       trivial@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] imxfb: correct location of callbacks in suspend and
 resume
Message-Id: <20100128001957.408936b2.akpm@linux-foundation.org>
In-Reply-To: <20100128074101.GA13756@pengutronix.de>
References: <1263226881-28008-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1264433854-878-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20100127154818.de91e255.akpm@linux-foundation.org>
	<20100128074101.GA13756@pengutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010 08:41:01 +0100 Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de> wrote:

> > What were the runtime effects of this bug?
> For me it was that in the original imxfb_info *fbi backlight_power was
> NULL but in imxfb_suspend it was 4 resulting in an oops as imxfb_suspend
> calls imxfb_disable_controller(fbi) which in turn has
> 
> 	if (fbi->backlight_power)
> 		fbi->backlight_power(0);

OK, thanks, that was important info.

I rescheduled the patch for 2.6.33 and marked it for 2.6.32.x backporting.
