Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbXKJWT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbXKJWT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbXKJWTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:19:49 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:42494 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbXKJWTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:19:48 -0500
Date: Sat, 10 Nov 2007 14:18:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Use CONFIG_64BIT to select between 32 and 64 bit
 in Kconfig
Message-Id: <20071110141858.f493508c.randy.dunlap@oracle.com>
In-Reply-To: <11947274093213-git-send-email-sam@ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org>
	<11947274093185-git-send-email-sam@ravnborg.org>
	<11947274091127-git-send-email-sam@ravnborg.org>
	<11947274093213-git-send-email-sam@ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007 21:43:27 +0100 Sam Ravnborg wrote:

> This change allow us to use the new syntax:
> make K64BIT={n,y} to select between 32 and 64 bit.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/x86/Kconfig |   26 ++++++++------------------
>  1 files changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 153c26c..0d86611 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1,34 +1,24 @@
>  # x86 configuration
>  
>  # Select 32 or 64 bit
> -choice
> -	bool "Select 32 or 64 bit"
> -	default X86_32
> +config 64BIT
> +	bool "64 Bit kernel"

	bool "64-bit kernel"

> +	default n
> +	help
> +	  Say yes to build a 64 bit kernel - formerly known as x86_64

	                     64-bit

> +	  Say no to build a 32 bit kernel - formerly known as i386

	                    32-bit

>  
>  config X86_32
> -	bool "32 bit (former ARCH=i386)"
> -	help
> -	  This is Linux's home port.  Linux was originally native to the Intel
> -	  386, and runs on all the later x86 processors including the Intel
> -	  486, 586, Pentiums, and various instruction-set-compatible chips by
> -	  AMD, Cyrix, and others.
> +	def_bool !64BIT
>  
>  config X86_64
> -	bool "64 bit (former ARCH=x86_64)"
> -	help
> -	  Port to the x86-64 architecture. x86-64 is a 64-bit extension to the
> -	  classical 32-bit x86 architecture. For details see
> -	  <http://www.x86-64.org/>.
> -endchoice
> +	def_bool 64BIT
>  
>  ### Arch settings
>  config X86
>  	bool
>  	default y
>  
> -config 64BIT
> -	def_bool X86_64
> -
>  config GENERIC_TIME
>  	bool
>  	default y
> -- 


---
~Randy
