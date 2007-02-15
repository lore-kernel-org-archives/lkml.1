Return-Path: <linux-kernel-owner+w=401wt.eu-S1030767AbXBOTbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030767AbXBOTbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030773AbXBOTbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:31:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:42444 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030767AbXBOTbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:31:43 -0500
X-Provags-ID: V01U2FsdGVkX18QK0hfFT4Qq3UK4GLz6ml/lQJMUKG9ABCQGi1gBR
	9h2A==
From: Helge Deller <deller@gmx.de>
To: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] HIL: fix improper call of release_region v2
Date: Thu, 15 Feb 2007 20:31:39 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@osdl.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
References: <20070215192513.GA12857@cvg>
In-Reply-To: <20070215192513.GA12857@cvg>
X-Face: *4/{KL3=jWs!v\UO#3e7~Vb1~CL@oP'~|*/M$!9`tb2[;fY@)WscF2iV7`,a$141g'o,=?utf-8?q?7X=0A=09=3FBt1Wb=3AL7K6z-?=<?-+-13|S_ixrq58*E`)ZkSe~NSI?u=89G'J<n]7\?[)LCCBZc}~[j(=?utf-8?q?e=7D=0A=09=60-QV=7B=23=25=26=5B=3F=5EfAke6t8QbP=3Bb=27XB?=,ZU84HeThMrO(@/K.`jxq9P({V(AzezCKMxk\F2^p^+"=?utf-8?q?=0A=09=5B?="ppalbA!zy-l)^Qa3*u/Z-1W3,o?2fes2_d\u=1\E9N+~Qo
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702152031.40145.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007, Cyrill V. Gorcunov wrote:
> Thist patch prevents from improper call of release_region
> if the code has been compiled without CONFIG_HP300 support.
> 
> Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>

Acked-by: Helge Deller <deller@gmx.de>

 
> ---
> 
> An improved version (v2). Helge, please check it and Ack then.
> 
>  drivers/input/keyboard/hilkbd.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/keyboard/hilkbd.c b/drivers/input/keyboard/hilkbd.c
> index 255a6ec..4de4dc2 100644
> --- a/drivers/input/keyboard/hilkbd.c
> +++ b/drivers/input/keyboard/hilkbd.c
> @@ -294,8 +294,10 @@ err3:
>  	disable_irq(HIL_IRQ);
>  	free_irq(HIL_IRQ, hil_dev.dev_id);
>  err2:
> +#if defined(CONFIG_HP300)
>  	release_region(HILBASE + HIL_DATA, 2);
>  err1:
> +#endif
>  	input_free_device(hil_dev.dev);
>  	hil_dev.dev = NULL;
>  	return err;
> 


