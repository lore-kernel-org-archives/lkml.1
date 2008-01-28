Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbYA1Jcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbYA1Jcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYA1Jcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:32:48 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59327 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752799AbYA1Jcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:32:47 -0500
Date: Mon, 28 Jan 2008 10:32:45 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org, David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH -mm 2/2] PWM LED driver
Message-ID: <20080128103245.32eba006@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080128012932.bfbbd97d.akpm@linux-foundation.org>
References: <1201185225-15789-1-git-send-email-hskinnemoen@atmel.com>
	<1201185225-15789-2-git-send-email-hskinnemoen@atmel.com>
	<1201185225-15789-3-git-send-email-hskinnemoen@atmel.com>
	<20080127213232.ade044d5.akpm@linux-foundation.org>
	<20080128101551.7cbc7af5@dhcp-252-066.norway.atmel.com>
	<20080128012932.bfbbd97d.akpm@linux-foundation.org>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 01:29:32 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > -	if (i > 0) {
> > -		for (i = i - 1; i >= 0; i--) {
> > -			led_classdev_unregister(&leds[i].cdev);
> > -			pwm_channel_free(&leds[i].pwmc);
> > -		}
> > +	while (i-- > 0) {
> > +		led_classdev_unregister(&leds[i].cdev);
> > +		pwm_channel_free(&leds[i].pwmc);
> >  	}  
> 
> Looks OK, although I'd say that `while (--i >= 0)' is more idiomatic -
> predecrement, postincrement and all that?

Maybe. while (i-- > 0) has the advantage that it will work even if i is
unsigned though...

Haavard
