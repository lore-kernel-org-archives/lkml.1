Return-Path: <linux-kernel-owner+w=401wt.eu-S1762073AbYGBJkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762073AbYGBJkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 05:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYGBJkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 05:40:47 -0400
Received: from bu3sch.de ([62.75.166.246]:60567 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbYGBJkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 05:40:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH RFC] x86: Add user configurable GPIO-lib support
Date: Wed, 2 Jul 2008 11:40:23 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lkml <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>
References: <200807011957.41837.david-b@pacbell.net>
In-Reply-To: <200807011957.41837.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807021140.23876.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2008 04:57:41 David Brownell wrote:
> More food for thought ... 
> 
> This makes the rdc321x support switch over to using gpiolib,
> along with all of x86.  Quick'n'dirty.
> 
> It's perhaps best done in conjunction with something to
> make GPIOLIB be user-configurable on systems where it's not
> already selected by platform code.  The rdc321x stuff needs
> more working, but this is a start.
> 
> - Dave
> 
> ---
>  arch/x86/Kconfig                            |    6 +
>  arch/x86/mach-rdc321x/gpio.c                |  107 ++++++++--------------------
>  arch/x86/mach-rdc321x/platform.c            |    3 
>  include/asm-x86/gpio.h                      |   22 +++++
>  include/asm-x86/mach-rdc321x/gpio.h         |   52 -------------
>  include/asm-x86/mach-rdc321x/rdc321x_defs.h |    2 
>  6 files changed, 62 insertions(+), 130 deletions(-)
> 
> --- a/arch/x86/Kconfig	2008-07-01 16:46:11.000000000 -0700
> +++ b/arch/x86/Kconfig	2008-07-01 16:46:13.000000000 -0700
> @@ -87,7 +87,10 @@ config GENERIC_HWEIGHT
>  	def_bool y
>  
>  config GENERIC_GPIO
> -	def_bool n
> +	def_bool y
> +
> +config HAVE_GPIO_LIB
> +	def_bool y

I think we should not unconditionally compile in gpiolib.
See my other patch that converts the stuff to be user selectable.

(Too bad all my mail bounces at Daves mailfilter and this won't reach him... :/ )


-- 
Greetings Michael.
