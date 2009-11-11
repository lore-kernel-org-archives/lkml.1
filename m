Return-Path: <linux-kernel-owner+w=401wt.eu-S1759539AbZKKWmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539AbZKKWmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbZKKWl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:41:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34254 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320AbZKKWl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:41:59 -0500
Message-ID: <4AFB3D31.6070901@zytor.com>
Date: Wed, 11 Nov 2009 14:39:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Ma, Ling" <ling.ma@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com> <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com> <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com> <4AF7C66C.6000009@zytor.com> <20091109080830.GI453@elte.hu> <8FED46E8A9CA574792FC7AACAC38FE7714FE830398@PDSMSX501.ccr.corp.intel.com> <20091111203425.GA25401@lenovo>
In-Reply-To: <20091111203425.GA25401@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 12:34 PM, Cyrill Gorcunov wrote:
>                        			memcpy_orig	memcpy_new
> TPT: Len 1024, alignment  8/ 0:		490		570
> TPT: Len 2048, alignment  8/ 0:		826		329
> TPT: Len 3072, alignment  8/ 0:		441		464
> TPT: Len 4096, alignment  8/ 0:		579		596
> TPT: Len 5120, alignment  8/ 0:		723		729
> TPT: Len 6144, alignment  8/ 0:		859		861
> TPT: Len 7168, alignment  8/ 0:		996		994
> TPT: Len 8192, alignment  8/ 0:		1165		1127
> TPT: Len 9216, alignment  8/ 0:		1273		1260
> TPT: Len 10240, alignment  8/ 0:	1402		1395
> TPT: Len 11264, alignment  8/ 0:	1543		1525
> TPT: Len 12288, alignment  8/ 0:	1682		1659
> TPT: Len 13312, alignment  8/ 0:	1869		1815
> TPT: Len 14336, alignment  8/ 0:	1982		1951
> TPT: Len 15360, alignment  8/ 0:	2185		2110
> 
> I've run this test a few times and results almost the same,
> with alignment 1024, 3072, 4096, 5120, 6144, new version a bit slowly.
> 

Was the result for 2048 consistent (it seems odd in the extreme)... the
discrepancy between this result and Ling's results bothers me; perhaps
the right answer is to leave the current code for Core2 and use new code
(with a lower than 1024 threshold?) for NHM and K8?

	-hpa
