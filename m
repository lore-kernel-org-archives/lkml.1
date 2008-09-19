Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYISQvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYISQvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 12:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYISQvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 12:51:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750876AbYISQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 12:51:33 -0400
Message-ID: <48D3D836.40306@linux-foundation.org>
Date: Fri, 19 Sep 2008 11:49:58 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org,
       penberg@cs.helsinki.fi
Subject: Re: [patch 3/4] cpu alloc: The allocator
References: <20080919145859.062069850@quilx.com> <20080919145929.158651064@quilx.com> <48D3D2EF.5090808@cosmosbay.com>
In-Reply-To: <48D3D2EF.5090808@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

>> +    unsigned long start;
>> +    int units = size_to_units(size);
>> +    void *ptr;
>> +    int first;
>> +    unsigned long flags;
>> +
>> +    if (!size)
>> +        return ZERO_SIZE_PTR;
>> +
>> +    WARN_ON(align > PAGE_SIZE);
> 
> if (align < UNIT_SIZE)
>     align = UNIT_SIZE;

size_to_units() does round up:


/*
 * How many units are needed for an object of a given size
 */
static int size_to_units(unsigned long size)
{
        return DIV_ROUND_UP(size, UNIT_SIZE);
}

