Return-Path: <linux-kernel-owner+w=401wt.eu-S1763857AbZDHVOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763857AbZDHVOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760450AbZDHVOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:14:24 -0400
Received: from blaine.gmane.org ([80.91.229.8]:50302 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947AbZDHVOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:14:23 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49DD136B.50300@lwfinger.net>
Date: Wed, 08 Apr 2009 16:13:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: public-alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@hugh.gmane.org,
       Larry Finger 
	<public-Larry.Finger-tQ5ms3gMjBLk1uMJSBkQmQ@hugh.gmane.org>,
       Rusty Russell 
	<public-rusty-8n+1lVoiYb80n/F98K4Iww@hugh.gmane.org>,
       Arjan van de Ven 
	<public-arjan-VuQAYsv1563Yd54FQh9/CA@hugh.gmane.org>,
       LKML <public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       "Rafael J. Wysocki" <public-rjw-KKrjLPT3xs0@hugh.gmane.org>,
       wireless 
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
Subject: Re: Regression in 2.6.30-rc1 since commit acae0515 - wireless broken
References: <49DC2DF5.3010603@lwfinger.net> <49DC31EA.8050208@linux.intel.com>	<200904081631.09150.rusty@rustcorp.com.au>	<49DCB976.4020200@lwfinger.net>	<9b2b86520904081006m6e6b5276v834c3565b0f6f4c7@mail.gmail.com> <m2fxgi6hdq.fsf@igel.home>
In-Reply-To: <m2fxgi6hdq.fsf@igel.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andreas Schwab wrote:
> 
> 
> Alan Jenkins <sourcejedi.lkml-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> writes:
> 
>> I agree that commit looks like it should be a no-op though :-).
> 
> But it isn't.
> 
> Andreas.
> 
> ---
> Fix try_then_request_module to use waiting __request_module again.
> 
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
>  include/linux/kmod.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.30-rc1/include/linux/kmod.h
> ===================================================================
> --- linux-2.6.30-rc1.orig/include/linux/kmod.h	2009-04-08 12:47:54.000000000 +0200
> +++ linux-2.6.30-rc1/include/linux/kmod.h	2009-04-08 17:39:35.000000000 +0200
> @@ -34,7 +34,7 @@ extern int __request_module(bool wait, c
>  #define request_module(mod...) __request_module(true, mod)
>  #define request_module_nowait(mod...) __request_module(false, mod)
>  #define try_then_request_module(x, mod...) \
> -	((x) ?: (__request_module(false, mod), (x)))
> +	((x) ?: (__request_module(true, mod), (x)))
>  #else
>  static inline int request_module(const char *name, ...) { return -ENOSYS; }
>  static inline int request_module_nowait(const char *name, ...) { return -ENOSYS; }
> 

Bingo. The above patch fixes my system. Andreas, you have a much sharper eye
than I do.

Feel free to add a Tested-by: Larry Finger <Larry.Finger@lwfinger.net> if you wish.

Larry


