Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYAWWH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYAWWH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbYAWWGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:06:49 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754741AbYAWWGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:06:48 -0500
Date: Wed, 23 Jan 2008 14:06:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       david-b@pacbell.net, linux@maxim.org.za,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] atmel_lcdfb: backlight control
Message-Id: <20080123140610.4509f165.akpm@linux-foundation.org>
In-Reply-To: <4790BB53.3080407@atmel.com>
References: <4790BB53.3080407@atmel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 18 Jan 2008 15:44:35 +0100 Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> On the sam9 EK boards, the LCD backlight is hooked up to a PWM output
> from the LCD controller.  It's controlled by "contrast" registers though.
> 
> This patch lets boards declare that they have that kind of backlight
> control.  The driver can then export this control, letting screenblank
> and other operations actually take effect ... reducing the typically
> substantial power drain from the backlight.
> 
> +static inline void init_backlight(struct atmel_lcdfb_info *sinfo)
> +static inline void exit_contrast(struct atmel_lcdfb_info *sinfo)
> +static inline void init_backlight(struct atmel_lcdfb_info *sinfo)
> +static inline void exit_contrast(struct atmel_lcdfb_info *sinfo)
> +static inline void init_contrast(struct atmel_lcdfb_info *sinfo)

You really don't need to add manual inlining.  The compiler takes
care of it.
