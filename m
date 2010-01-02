Return-Path: <linux-kernel-owner+w=401wt.eu-S1751992Ab0ABTaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab0ABTaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567Ab0ABTaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:30:20 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:36699 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0ABTaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:30:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b37GZfGLcjlD+v4sr1dV1RkGp5Vx6y1+BEgQJRuINatl2gX3syqy5jKtrChlAprwT6
         CKdNnmap/q0D9fVd01CheCC5wUE+a9WRt/BHdeA4ds4Q741VpVQz0mELW8krOJ9y63FG
         tHnhd3xXpm2LPMHwN9JJxpUn+5Q8SH0ctmwF4=
Date: Sat, 2 Jan 2010 11:30:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: tglx@linutronix.de, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] timer: Introduce mod_timer_msec()
Message-ID: <20100102193013.GA2232@core.coreip.homeip.net>
References: <20100102104853.28505e39@infradead.org>
 <20100102105012.40d678f2@infradead.org>
 <877hs0724u.fsf@basil.nowhere.org>
 <20100102112108.574396fd@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100102112108.574396fd@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 11:21:08AM -0800, Arjan van de Ven wrote:
>  /**
> + * mod_timer_msec - modify a timer's timeout, using relative milliseconds
> + * @timer: the timer to be modified
> + * @delay_ms: the desired minimum delay in milliseconds
> + *
> + * Changes the timeout of a timer similar to mod_timer().
> + *
> + * mod_timer_msec() takes relative milliseconds rather than absolute
> + * jiffies as argument.
> + *
> + * The function returns whether it has modified a pending timer or not.
> + * (ie. mod_timer_msec() of an inactive timer returns 0, mod_timer_msec() of
> + * an active timer returns 1.)
> + */
> +int mod_timer_msec(struct timer_list *timer, unsigned long delay_ms)
> +{
> +	return mod_timer(timer, jiffies + msecs_to_jiffies(delay_ms));
> +}
> +EXPORT_SYMBOL(mod_timer_msec);

I wonder why isn't this an inline function? Seems tiny enough...  Other
than that -  I'll gladly take input conversion patches.

Thanks.

-- 
Dmitry
