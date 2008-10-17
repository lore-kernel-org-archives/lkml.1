Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbYJQP4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbYJQP4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbYJQPzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:55:38 -0400
Received: from gw.goop.org ([64.81.55.164]:60361 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758108AbYJQPze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:55:34 -0400
Message-ID: <48F8B574.7070401@goop.org>
Date: Fri, 17 Oct 2008 08:55:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: add missed clobber for 32-bit memmove
References: <1224249353-3032-1-git-send-email-albcamus@gmail.com> <1224249353-3032-2-git-send-email-albcamus@gmail.com>
In-Reply-To: <1224249353-3032-2-git-send-email-albcamus@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jike Song wrote:
> memmove() is implemented by inline assembly. It calls std at first
> and cld at last, but EFLAGS still should be clobbered.
>   

I think x86 gcc assumes "cc" is always clobbered by asms.  Otherwise 
there'll need to be a lot more "cc" clobbers than this...

    J

> Signed-off-by: Jike Song <albcamus@gmail.com>
> ---
>  arch/x86/lib/memcpy_32.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
> index 5415a9d..99a8240 100644
> --- a/arch/x86/lib/memcpy_32.c
> +++ b/arch/x86/lib/memcpy_32.c
> @@ -36,7 +36,7 @@ void *memmove(void *dest, const void *src, size_t n)
>  			:"0" (n),
>  			 "1" (n-1+src),
>  			 "2" (n-1+dest)
> -			:"memory");
> +			:"cc", "memory");
>  	}
>  	return dest;
>  }
>   

