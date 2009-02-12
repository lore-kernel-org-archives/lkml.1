Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbZBLLXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbZBLLXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZBLLXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:23:15 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:12587 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZBLLXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:23:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qda30prFg9A2qnD7hHidBzSy15t/lmFlv0lB4GwlDdmu2y8unniP/CpSw/1yUn7p+k
         Evw3OO+w37Dq2lEoki29VkFKWsPGSDKbVCwDGVt7Ixt0lIvhJF1F8G+5XeTwPk8M9DOA
         6kr6SgJo0mj9EzxzjxpuBeZ77jaXAjF2aPoRc=
MIME-Version: 1.0
In-Reply-To: <20090212.030926.74125778.davem@davemloft.net>
References: <20090212.021527.12463602.davem@davemloft.net>
	 <1234434959.29851.55.camel@pasglop>
	 <20090212.030926.74125778.davem@davemloft.net>
Date: Thu, 12 Feb 2009 21:23:13 +1000
Message-ID: <21d7e9970902120323y4f16693dk77955c7c646ac744@mail.gmail.com>
Subject: Re: [PATCH 1/5]: drm: ati_pcigart: Do not access I/O MEM space using 
	pointer derefs.
From: Dave Airlie <airlied@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 9:09 PM, David Miller <davem@davemloft.net> wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Thu, 12 Feb 2009 21:35:59 +1100
>
>> Oh BTW something else to be careful with, though I suppose it's working
>> some what by accident right now... when the GART is in the frame buffer
>> it gets applied the current fb swapper setting... ouch !
>>
>> So it might be a good idea, if we're going to use DRM_READ/WRITE32 which
>> afaik are readl/writel (ie, swapping) to make sure we at least
>> temporarily disable that swapper while whacking the GART.
>
> Cute.

Dave,

are you on a PCI or PCIE card, I've no idea what buses you have on sparc64.

On the PCI cards the GART table will always be in main memory.
PCIE always in VRAM.

Dave.

>
> I wonder if this is what is tripping me up.
>
> But, looking more closely, it appears that:
>
> 1) The kernel radeon framebuffer driver doesn't mess with
>   the framebuffer endianness setting.
>
> 2) On >= R300 (which my chip is), Xorg leaves it alone too.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
