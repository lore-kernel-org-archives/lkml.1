Return-Path: <linux-kernel-owner+w=401wt.eu-S1767409AbXECFsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767409AbXECFsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 01:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767407AbXECFsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 01:48:51 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767405AbXECFsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 01:48:50 -0400
Date: Wed, 2 May 2007 22:48:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: thomas@winischhofer.net, LKML <linux-kernel@vger.kernel.org>,
       Wang Ya-gang <lazy_linux@126.com>, Chen Li-jun <cljun@xiyou.edu.cn>
Subject: Re: [Patch][SIS USB2VGA] Warning fix
Message-Id: <20070502224841.030091cd.akpm@linux-foundation.org>
In-Reply-To: <20070503053429.GA3166@localhost.localdomain>
References: <20070503053429.GA3166@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007 13:34:29 +0800 WANG Cong <xiyou.wangcong@gmail.com> wrote:

> 
> Fix this warning:
> drivers/usb/misc/sisusbvga/sisusb_con.c:1436: warning: initialization from incompatible pointer type
> 
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> ---
> 
> Compiling test past.;)
> 

Thanks.

> --- linux-2.6.21-rc7-mm2/drivers/usb/misc/sisusbvga/sisusb_con.c.orig	2007-05-03 02:51:06.000000000 +0800
> +++ linux-2.6.21-rc7-mm2/drivers/usb/misc/sisusbvga/sisusb_con.c	2007-05-03 02:57:08.000000000 +0800
> @@ -321,9 +321,10 @@ sisusbcon_deinit(struct vc_data *c)
>  /* interface routine */
>  static u8
>  sisusbcon_build_attr(struct vc_data *c, u8 color, u8 intensity,
> -			    u8 blink, u8 underline, u8 reverse)
> +			    u8 blink, u8 underline, u8 reverse, u8 unused)
>  {
>  	u8 attr = color;
> +	(void) unused;

This part isn't needed and we don't usually do it - the compiler will not warn
about the unused arg.

