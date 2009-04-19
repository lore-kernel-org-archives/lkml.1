Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbZDSC7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbZDSC7a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 22:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbZDSC7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 22:59:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:3048 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZDSC7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 22:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pVCNwkWqeX11y5OVke4LKD5DUPYRzSDYECHPKxa4IE73ECiZPe9JW7PHIg3bmKdpVB
         u82QaaW1xv3uyTMlsDSHvswxddBIS0CUZtUsTKNxKQw1KtVsS5hMvAwsCz+Mm98dAy7T
         55kJ67m3kOEXYFV1z4s5eYhH8jzO+VDfy53Nw=
MIME-Version: 1.0
In-Reply-To: <b9df5fa10904181956x3f6b15ebpb5e40e1d722dbb46@mail.gmail.com>
References: <b9df5fa10904181956x3f6b15ebpb5e40e1d722dbb46@mail.gmail.com>
Date: Sun, 19 Apr 2009 08:59:19 +0600
Message-ID: <b9df5fa10904181959q5f544828ic4db185f0f9d9640@mail.gmail.com>
Subject: Re: [PATCH] mfd: Mark clocks_init as non-init in twl4030-core.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/09, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>  Impact: Fix section mismatch.
>
> clocks_init() has been called from twl4030_probe() which is a non-init
> function. Since probing can be done anytime so clocks_init will be
> called anytime too. So we mark clock_init() as non-init.
>
> LD      drivers/mfd/built-in.o
> WARNING: drivers/mfd/built-in.o(.text+0x8dd9): Section mismatch in
> reference from the function twl4030_probe() to the function
> .init.text:clocks_init()
> The function twl4030_probe() references
> the function __init clocks_init().
> This is often because twl4030_probe lacks a __init
> annotation or the annotation of clocks_init is wrong.
>
> ---
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>
> --- linus/drivers/mfd/twl4030-core.c	2009-03-26 06:26:44.000000000 +0600
> +++ rakib/drivers/mfd/twl4030-core.c	2009-03-26 21:51:53.604077256 +0600
> @@ -649,7 +649,7 @@ static inline int __init unprotect_pm_ma
>  	return e;
>  }
>
> -static void __init clocks_init(struct device *dev)
> +static void clocks_init(struct device *dev)
>  {
>  	int e = 0;
>  	struct clk *osc;
>
