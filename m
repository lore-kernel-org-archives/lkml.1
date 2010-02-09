Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0BIViQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 16:38:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:51687 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab0BIViN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 16:38:13 -0500
Message-ID: <4B71D580.805@kernel.org>
Date: Tue, 09 Feb 2010 13:37:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 15/35] x86: make 64 bit use early_res instead of bootmem
 before slab
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>	<1265743966-17065-16-git-send-email-yinghai@kernel.org> <20100209122632.fc4be9c1.akpm@linux-foundation.org>
In-Reply-To: <20100209122632.fc4be9c1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 12:26 PM, Andrew Morton wrote:
> On Tue, 09 Feb 2010 11:32:26 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> +u64 __init find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
>> +			 u64 size, u64 align)
>> +{
>> +	u64 addr, last;
>> +
>> +	addr = round_up(ei_start, align);
> 
> Can we use include/linux/log2.h:roundup_pow_of_two() in this patchset?

no, that is not what we want.


/**
 * roundup_pow_of_two - round the given value up to nearest power of two
 * @n - parameter
 *
 * round the given value up to the nearest power of two
 * - the result is undefined when n == 0
 * - this can be used to initialise global variables from constant data
 */
#define roundup_pow_of_two(n)                   \
(                                               \
        __builtin_constant_p(n) ? (             \
                (n == 1) ? 1 :                  \
                (1UL << (ilog2((n) - 1) + 1))   \
                                   ) :          \
        __roundup_pow_of_two(n)                 \
 )

YH
