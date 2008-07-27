Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYG0EFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYG0EFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 00:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYG0EEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 00:04:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:26712 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbYG0EEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 00:04:48 -0400
Date: Sat, 26 Jul 2008 20:08:57 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Trent Piepho <tpiepho@freescale.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] leds: make the default trigger name const
Message-ID: <20080727020857.GM12191@secretlab.ca>
References: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp> <1217019705-24244-1-git-send-email-tpiepho@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217019705-24244-1-git-send-email-tpiepho@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 02:01:44PM -0700, Trent Piepho wrote:
> The default_trigger fields of struct gpio_led and thus struct led_classdev
> are pretty much always assigned from a string literal, which means the
> string can't be modified.  Which is fine, since there is no reason to
> modify the string and in fact it never is.
> 
> But they should be marked const to prevent such code from being added, to
> prevent warnings if -Wwrite-strings is used and when assigned from a
> constant string other than a string literal (which produces a warning under
> current kernel compiler flags), and for general good coding practices.
> 
> Signed-off-by: Trent Piepho <tpiepho@freescale.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  include/linux/leds.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 519df72..defe693 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -48,7 +48,7 @@ struct led_classdev {
>  
>  	struct device		*dev;
>  	struct list_head	 node;			/* LED Device list */
> -	char			*default_trigger;	/* Trigger to use */
> +	const char		*default_trigger;	/* Trigger to use */
>  
>  #ifdef CONFIG_LEDS_TRIGGERS
>  	/* Protects the trigger data below */
> @@ -121,7 +121,7 @@ extern void ledtrig_ide_activity(void);
>  /* For the leds-gpio driver */
>  struct gpio_led {
>  	const char *name;
> -	char *default_trigger;
> +	const char *default_trigger;
>  	unsigned 	gpio;
>  	u8 		active_low;
>  };
> -- 
> 1.5.4.3
> 
