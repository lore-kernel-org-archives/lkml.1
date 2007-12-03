Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbXLCNnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbXLCNnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 08:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXLCNnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 08:43:33 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:57055 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbXLCNnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 08:43:32 -0500
Date: Mon, 03 Dec 2007 22:45:46 +0900 (JST)
Message-Id: <20071203.224546.35471256.anemo@mba.ocn.ne.jp>
To: giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: heartbeat for leds on i2c bus
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20071203103557.GT10305@enneenne.com>
References: <20071203103557.GT10305@enneenne.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 11:35:57 +0100, Rodolfo Giometti <giometti@enneenne.com> wrote:
> If I try to use the heartbeat trigger I hang the system... I suppose
> it is due the fact the led_set_brightness() function is called inside
> a kernel timer.
> 
> How I can solve this problem? I thought to modify the trigger adding a
> kernel thread who manage the led which in turn is controlled by the
> kernel timer. It could be the right solution?

Yes, the heartbeat trigger driver assumes brightness_set() routine can
be called from timer.  Other led-triggers also have this assumption.

So I'd suggest using workqueue for your led driver, as like as the
leds-gpio driver.  Or you can just use the leds-gpio driver and
implement the gpio interface (gpio_set_value_cansleep) instead of the
led interface.

---
Atsushi Nemoto
