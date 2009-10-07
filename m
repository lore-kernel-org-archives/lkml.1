Return-Path: <linux-kernel-owner+w=401wt.eu-S1759534AbZJGRqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534AbZJGRqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbZJGRqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:46:14 -0400
Received: from mga10.intel.com ([192.55.52.92]:17213 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757627AbZJGRqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:46:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,520,1249282800"; 
   d="scan'208";a="733907945"
Message-ID: <4ACCD3A6.9000306@linux.intel.com>
Date: Wed, 07 Oct 2009 10:45:10 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.32-rc3: floating-point build failure (undefined reference
 to `__udivdi3' in menu governor)
References: <20091007104125.GA1449@rhlx01.hs-esslingen.de> <4ACCA44B.3070706@linux.intel.com> <20091007173457.GA25415@rhlx01.hs-esslingen.de>
In-Reply-To: <20091007173457.GA25415@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> Hi,
>> looking at it, can you try sticking (u32) at the end of line 212; that multiply is not very likely to exceed 32 bits
> 
> Nopeee.
> 
>         data->predicted_us = DIV_ROUND_CLOSEST((u32)
>                 data->expected_us * data->correction_factor[data->bucket],
>                 (u32)RESOLUTION * DECAY);
> 
> It did properly rebuild drivers/cpuidle/governors/menu.o.
> Still happening.
> IOW it must be somewhere inside the DIV_ROUND_CLOSEST macro or so.

it looks like your GCC has a problem dividing by a power of two though;
both DECAY and RESOLUTION are powers of two...

