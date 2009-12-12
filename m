Return-Path: <linux-kernel-owner+w=401wt.eu-S933493AbZLLCR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbZLLCR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 21:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbZLLCRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 21:17:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47550 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763080AbZLLCRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 21:17:54 -0500
Message-ID: <4B22FD0B.10506@zytor.com>
Date: Fri, 11 Dec 2009 18:16:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 61/7] x86/pci: add cap_4g
References: <4B22D4DA.2000104@kernel.org> <4B22D74D.4020201@kernel.org> <4B22FBEB.7040204@kernel.org>
In-Reply-To: <4B22FBEB.7040204@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2009 06:11 PM, Yinghai Lu wrote:
>  
> +static inline u64 cap_4g(u64 val)
> +{
> +	if (sizeof(resource_size_t) >= sizeof(u64))
> +		return val;
> +
> +	if (val < 1ULL)
> +		return val;
> +
> +	return 0xffffffff;
> +}
>  #endif

How about:

static inline resource_size_t cap_resource(u64 val)
{
	if (val > ~(resource_size_t)0)
		return ~(resource_size_t)0;
	else
		return val;
}


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

