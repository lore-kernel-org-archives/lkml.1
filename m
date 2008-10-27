Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbYJ0EYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbYJ0EYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 00:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbYJ0EYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 00:24:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbYJ0EYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 00:24:39 -0400
Date: Sun, 26 Oct 2008 21:24:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix comile error of hdpuftrs
Message-Id: <20081026212401.f3a6ee4d.akpm@linux-foundation.org>
In-Reply-To: <200810181537.13653.m.kozlowski@tuxland.pl>
References: <200810181537.13653.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008 15:37:12 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> drivers/misc/hdpuftrs/hdpu_nexus.c:118: error: expected identifier or '(' before 'return'
> drivers/misc/hdpuftrs/hdpu_nexus.c:119: error: expected identifier or '(' before '}' token
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
> --- a/drivers/misc/hdpuftrs/hdpu_nexus.c
> +++ b/drivers/misc/hdpuftrs/hdpu_nexus.c
> @@ -113,7 +113,6 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
>  	if (!hdpu_chassis_id)
>  		printk(KERN_WARNING "sky_nexus: "
>  		       "Unable to create proc dir entry: sky_chassis_id\n");
> -	}
> 
>  	return 0;
>  }

This has been broken since 2.6.26.

Nobody noticed because there is no way of enabling CONFIG_HDPU_FEATURES
in Kconfig.  I wonder what's up with that.

