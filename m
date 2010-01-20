Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310Ab0ATUCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab0ATUCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082Ab0ATUCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:02:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:49437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0ATUCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:02:22 -0500
Message-ID: <4B576126.1020404@kernel.org>
Date: Wed, 20 Jan 2010 12:01:42 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 22/37] move round_up/down to kernel.h
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-23-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001191155540.22304@router.home>
In-Reply-To: <alpine.DEB.2.00.1001191155540.22304@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 09:57 AM, Christoph Lameter wrote:
> On Fri, 15 Jan 2010, Yinghai Lu wrote:
> 
>>
>>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>>
>> +/*
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
> Note the last two lines! We already have roundup(), DIV_ROUND_UP and
> DIV_ROUND_CLOSEST. Please integrate them properly. Maybe extract
> __round_mask() from all of them.

will do that in following patches...

Thanks

Yinghai
