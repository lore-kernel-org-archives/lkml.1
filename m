Return-Path: <linux-kernel-owner+w=401wt.eu-S1764300AbXJFAAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764300AbXJFAAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 20:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761528AbXJFAAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 20:00:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761666AbXJFAAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 20:00:21 -0400
Date: Fri, 5 Oct 2007 17:00:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org, adaplas@gmail.com
Subject: Re: [PATCH] vc bell config
Message-Id: <20071005170011.b4d280bf.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0710051347000.13406@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710051347000.13406@fbirervta.pbzchgretzou.qr>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007 13:55:52 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> It is already possible to deactivate the vc bell on a per-tty basis,
> by using echo -en "\e[11;0]", but this is reset on reset(1).
> 
> This adds a sysfs parameter to globally control the vc bell, as well
> as sysfs parameters for default pitch and duration.
> 

Why do we need this?  To fix the stupid-app-makes-my-box-beep problem, I
guess.  Is there no other way of suppressing the beep? (no jokes about wire
cutters or earplugs, please).


> ---
>  drivers/char/vt.c |   18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6.23/drivers/char/vt.c
> ===================================================================
> --- linux-2.6.23.orig/drivers/char/vt.c
> +++ linux-2.6.23/drivers/char/vt.c
> @@ -134,8 +134,12 @@ const struct consw *conswitchp;
>  /*
>   * Here is the default bell parameters: 750HZ, 1/8th of a second
>   */
> -#define DEFAULT_BELL_PITCH	750
> -#define DEFAULT_BELL_DURATION	(HZ/8)
> +static unsigned int default_bell_pitch = 750;
> +static unsigned int default_bell_duration = HZ / 8;

It is inapt to call these default_X.  Because once they have been altered
by the user, they aren't defaults any more.

They should be just bell_pitch and bell_duration.

