Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYHKUuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYHKUuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYHKUt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:49:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201AbYHKUt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:49:56 -0400
Date: Mon, 11 Aug 2008 13:49:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Claudio Nieder <private@claudio.ch>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Backlight driver for Tabletkiosk Sahara TouchIT-213
 Tablet PC
Message-Id: <20080811134940.b3bcde83.akpm@linux-foundation.org>
In-Reply-To: <488E25F4.4020405@claudio.ch>
References: <488E0D2A.1000005@claudio.ch>
	<1217270428.6059.39.camel@dax.rpnet.com>
	<488E25F4.4020405@claudio.ch>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 22:03:00 +0200
Claudio Nieder <private@claudio.ch> wrote:

>
> ...
>
> +void kb3886_bl_set_intensity(int intensity)
> +{
> +	mutex_lock(&bl_mutex);
> +	intensity = intensity&0xff;
> +	outb(KB3886_ADC_DAC_PWM, KB3886_PARENT);
> +	mdelay(10);
> +	outb(KB3886_PWM0_WRITE, KB3886_IO);
> +	mdelay(10);
> +	outb(intensity, KB3886_IO);
> +	mutex_unlock(&bl_mutex);
> +}

I believe the mdelay()s could be converted to the preferable msleep()?

> ...
>
