Return-Path: <linux-kernel-owner+w=401wt.eu-S966434AbXHGWHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966434AbXHGWHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966915AbXHGVpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:45:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56814 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966001AbXHGVpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:45:00 -0400
Date: Tue, 7 Aug 2007 23:44:58 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, davi@haxent.com.br, mtk-manpages@gmx.net,
       davidel@xmailserver.org
Subject: Re: [2.6.22.2 review 26/84] make timerfd return a u64 and fix the
 __put_user
In-Reply-To: <20070807204459.GA23028@kroah.com>
Message-ID: <Pine.LNX.4.64.0708072343390.26397@fbirervta.pbzchgretzou.qr>
References: <20070807204034.882009319@mini.kroah.org> <20070807204459.GA23028@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7 2007 13:44, Greg KH wrote:
>--- a/fs/timerfd.c
>+++ b/fs/timerfd.c
>@@ -95,7 +95,7 @@ static ssize_t timerfd_read(struct file 
> {
> 	struct timerfd_ctx *ctx = file->private_data;
> 	ssize_t res;
>-	u32 ticks = 0;
>+	u64 ticks = 0;
> 	DECLARE_WAITQUEUE(wait, current);
> 
> 	if (count < sizeof(ticks))
>@@ -130,7 +130,7 @@ static ssize_t timerfd_read(struct file 
> 			 * callback to avoid DoS attacks specifying a very
> 			 * short timer period.
> 			 */
>-			ticks = (u32)
>+			ticks = (u64)
> 				hrtimer_forward(&ctx->tmr,
> 						hrtimer_cb_get_time(&ctx->tmr),
> 						ctx->tintv);

[ Minor: Cast is not strictly required; hrtimer_forward()s result is
autopromoted/demoted to the type of @ticks. ]



	Jan
-- 
