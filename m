Return-Path: <linux-kernel-owner+w=401wt.eu-S1030549AbXBOSyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030549AbXBOSyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030550AbXBOSyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:54:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:57559 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030549AbXBOSyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:54:37 -0500
X-Provags-ID: V01U2FsdGVkX18/FYZdhqM/5XSj3jURXKZB9jy4nl0HRbWDqsaFZ9
	A05g==
From: Helge Deller <deller@gmx.de>
To: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
Subject: Re: [PATCH] HIL: fix improper call of release_region
Date: Thu, 15 Feb 2007 19:54:33 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
References: <20070215175031.GA12012@cvg>
In-Reply-To: <20070215175031.GA12012@cvg>
X-Face: *4/{KL3=jWs!v\UO#3e7~Vb1~CL@oP'~|*/M$!9`tb2[;fY@)WscF2iV7`,a$141g'o,=?utf-8?q?7X=0A=09=3FBt1Wb=3AL7K6z-?=<?-+-13|S_ixrq58*E`)ZkSe~NSI?u=89G'J<n]7\?[)LCCBZc}~[j(=?utf-8?q?e=7D=0A=09=60-QV=7B=23=25=26=5B=3F=5EfAke6t8QbP=3Bb=27XB?=,ZU84HeThMrO(@/K.`jxq9P({V(AzezCKMxk\F2^p^+"=?utf-8?q?=0A=09=5B?="ppalbA!zy-l)^Qa3*u/Z-1W3,o?2fes2_d\u=1\E9N+~Qo
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702151954.33474.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

please include the "err1" label as well inside the #if / #endif clause.
err1 is used only when CONFIG_HP300 is defined and in the parisc-case you currently get an unused label warning...

Helge

On Thursday 15 February 2007, Cyrill V. Gorcunov wrote:
> Thist patch prevents from improper call of release_region
> if the code has been compiled without CONFIG_HP300 support.
> 
> Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
> 
> ---
> 
>  drivers/input/keyboard/hilkbd.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/keyboard/hilkbd.c b/drivers/input/keyboard/hilkbd.c
> index 255a6ec..c3c0da3 100644
> --- a/drivers/input/keyboard/hilkbd.c
> +++ b/drivers/input/keyboard/hilkbd.c
> @@ -294,7 +294,9 @@ err3:
>  	disable_irq(HIL_IRQ);
>  	free_irq(HIL_IRQ, hil_dev.dev_id);
>  err2:
> +#if defined(CONFIG_HP300)
>  	release_region(HILBASE + HIL_DATA, 2);
> +#endif
>  err1:
>  	input_free_device(hil_dev.dev);
>  	hil_dev.dev = NULL;
> 


