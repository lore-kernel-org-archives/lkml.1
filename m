Return-Path: <linux-kernel-owner+w=401wt.eu-S1762084AbXGQG6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762084AbXGQG6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 02:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbXGQG6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 02:58:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34998 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754364AbXGQG57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 02:57:59 -0400
Date: Mon, 16 Jul 2007 23:57:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: federico ferri <xaero@inwind.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] change SysRq keycode for systems without SysRq key
Message-Id: <20070716235748.33d50a53.akpm@linux-foundation.org>
In-Reply-To: <4697ECA1.4070200@inwind.it>
References: <4697ECA1.4070200@inwind.it>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 23:20:33 +0200 federico ferri <xaero@inwind.it> wrote:

>  #ifdef CONFIG_MAGIC_SYSRQ	       /* Handle the SysRq Hack */
> -	if (keycode == KEY_SYSRQ && (sysrq_down || (down == 1 && sysrq_alt))) {
> +	if (keycode == CONFIG_MAGIC_SYSRQ_KEYCODE && (sysrq_down || (down == 1 && sysrq_alt))) {
>  		sysrq_down = down;
>  		return;
>  	}
> diff -uprN linux.orig/lib/Kconfig.debug linux/lib/Kconfig.debug
> --- linux.orig/lib/Kconfig.debug	2005-07-09 21:47:22.000000000 +0200
> +++ linux/lib/Kconfig.debug	2005-07-09 21:50:44.000000000 +0200
> @@ -28,6 +28,16 @@ config MAGIC_SYSRQ
>  	  send a BREAK and then within 5 seconds a command keypress. The
>  	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
>  	  unless you really know what this hack does.
> +	  
> +config MAGIC_SYSRQ_KEYCODE
> +	int
> +	prompt "Change SysRq key-code" if MAGIC_SYSRQ
> +	default 99
> +	depends on MAGIC_SYSRQ
> +	help
> +	  If your keyboard doesn't have a SysRq key (also labeled PrintScr),
> +	  you can specify another keycode which should act as SysRq.
> +	  Default is 99 (KEY_SYSRQ).
> +	  You can find this number using programs like evtest, or (maybe)
> +	  showkey.
>  

Seems harmless enough ;)

Could you please send in a suitable update to Documentation/sysrq.txt?
