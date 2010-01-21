Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497Ab0AUXOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0AUXOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 18:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469Ab0AUXOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 18:14:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58904 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab0AUXOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 18:14:38 -0500
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 22/36] move round_up/down to kernel.h
From: Andi Kleen <andi@firstfloor.org>
References: <1264055303-15123-1-git-send-email-yinghai@kernel.org>
	<1264055303-15123-23-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.00.1001211446430.13130@router.home>
Date: Fri, 22 Jan 2010 00:14:36 +0100
In-Reply-To: <alpine.DEB.2.00.1001211446430.13130@router.home> (Christoph Lameter's message of "Thu, 21 Jan 2010 14:48:24 -0600 (CST)")
Message-ID: <87fx5z2gpv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:

> On Wed, 20 Jan 2010, Yinghai Lu wrote:
>
>> + * This looks more complex than it should be. But we need to
>> + * get the type for the ~ right in round_down (it needs to be
>> + * as wide as the result!), and we want to evaluate the macro
>> + * arguments just once each.
>> + */
>> +#define __round_mask(x,y) ((__typeof__(x))((y)-1))
>> +#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
>> +#define round_down(x,y) ((x) & ~__round_mask(x,y))
>> +
>>  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
>>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>>  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
>
> So we are back to the earlier version.
>
> Two functions doing the same thing. round_up and roundup.
>
> If they are different(are they really used that way?) then they should
> have names that emphasize the difference.


round_up() basically only works for power of two, but they
should generate the same code for constants.

The only user right now is e820.c, but it uses the second
argument with non constants, so would generate a slower
true division with roundup() Right now it probably doesn't
make much difference because e820 lists are small, but I saw
a patchkit to let e820 replace bootmem and then they might
not be anymore.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
