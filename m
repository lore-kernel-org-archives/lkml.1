Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbZBUGMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbZBUGMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 01:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZBUGMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 01:12:16 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:42473 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZBUGMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 01:12:15 -0500
Date: Fri, 20 Feb 2009 22:12:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Cheng Renquan <crquan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Cheng Renquan <chengrq@uit.com.cn>
Subject: Re: [PATCH] [KBUILD] add symbol value to help find the real depend
Message-Id: <20090220221249.9350c317.randy.dunlap@oracle.com>
In-Reply-To: <1234944825-10299-1-git-send-email-crquan@gmail.com>
References: <1234944825-10299-1-git-send-email-crquan@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.499F9B28.0146:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 16:13:45 +0800 Cheng Renquan wrote:

> From: Cheng Renquan <chengrq@uit.com.cn>
> 
> kbuild-menuconfig-display-depend-value.patch
> 
> Sometimes when configuring need to disable some unused item, but the item is
> selected by many other items, it's hard to find the real dependency which
> selected it, This patch add every symbol's value accompanied to make it
> possible to find the real dependency easily.
> 
> An example is CONFIG_RFKILL,
> 
>   ---------------------- RF switch subsystem support ----------------------
>   | CONFIG_RFKILL:                                                        |
>   |                                                                       |
>   | Say Y here if you want to have control over RF switches               |
>   | found on many WiFi and Bluetooth cards.                               |
>   |                                                                       |
>   | To compile this driver as a module, choose M here: the                |
>   | module will be called rfkill.                                         |
>   |                                                                       |
>   | Symbol: RFKILL [=m]                                                   |
>   | Prompt: RF switch subsystem support                                   |
>   |   Defined at net/rfkill/Kconfig:4                                     |
>   |   Depends on: NET [=y]                                                |
>   |   Location:                                                           |
>   |     -> Networking support (NET [=y])                                  |
>   |   Selected by: IWLCORE [=n] && NETDEVICES [=y] && !S390 [=S390] && PC |
>   |                                                                       |
>   ----------------------------------------------------------------( 99%)---
> 
> Signed-off-by: Cheng Renquan <chengrq@uit.com.cn>
> 
> ---
> 
> Index: linux-2.6.29-rc5-lio/scripts/kconfig/expr.c
> ===================================================================
> --- linux-2.6.29-rc5-lio.orig/scripts/kconfig/expr.c
> +++ linux-2.6.29-rc5-lio/scripts/kconfig/expr.c
> @@ -1098,6 +1098,9 @@ void expr_fprint(struct expr *e, FILE *o
>  static void expr_print_gstr_helper(void *data, struct symbol *sym, const char *str)
>  {
>  	str_append((struct gstr*)data, str);
> +	if (sym)
> +		str_printf((struct gstr *)data, " [=%s]",
> +				sym_get_string_value(sym));
>  }
>  
>  void expr_gstr_print(struct expr *e, struct gstr *gs)
> --

Hi,

This looks good/helpful.  Can it be made to work with
gconfig & xconfig as well as menuconfig?

Thanks,
---
~Randy
