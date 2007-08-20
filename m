Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbXHTXfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbXHTXfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXHTXe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:34:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:3038 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbXHTXe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U9/X2YhF1Qmfe7SbU935QDxZRANDCJfA02n1Q9J7oatJIzrSFh3LzM6LMc5iWFlre4t3+ypny6PYtuSyjufka0UiPjakYCbm/Y63j6pQ4LeliTLHwOAdv1u3lWx01/P/NwXyVyftr37kKWVt+LT7z1NuCTHb+8de9or9sMYftSs=
Message-ID: <646765f40708201634u5437f307l8259456c92af5cf5@mail.gmail.com>
Date: Tue, 21 Aug 2007 09:34:56 +1000
From: "Julian Calaby" <julian.calaby@gmail.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 21/23] Add cmpxchg_local to sparc64
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, clameter@sgi.com,
       sparclinux@vger.kernel.org, wli@holomorphy.com
In-Reply-To: <20070820201831.178200926@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070820201519.512791382@polymtl.ca>
	 <20070820201831.178200926@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> Use cmpxchg_u32 and cmpxchg_u64 for cmpxchg_local and cmpxchg64_local. For other
> type sizes, use the new generic cmpxchg_local (disables interrupt).
>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: clameter@sgi.com
> CC: sparclinux@vger.kernel.org
> CC: wli@holomorphy.com
> ---
>  include/asm-sparc64/system.h |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> Index: linux-2.6-lttng/include/asm-sparc64/system.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-sparc64/system.h   2007-08-07 14:31:51.000000000 -0400
> +++ linux-2.6-lttng/include/asm-sparc64/system.h        2007-08-07 15:13:05.000000000 -0400
> @@ -314,6 +314,32 @@ __cmpxchg(volatile void *ptr, unsigned l
>                                     (unsigned long)_n_, sizeof(*(ptr))); \
>    })
>
> +#include <asm-generic/cmpxchg-local.h>

Shouldn't #includes go at the start of the file?

-- 

Julian Calaby

Email: julian.calaby@gmail.com
