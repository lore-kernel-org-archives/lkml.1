Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147Ab0ATTiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab0ATTiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097Ab0ATTit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:38:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:49977 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab0ATTis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:38:48 -0500
Message-ID: <4B575B68.4030809@kernel.org>
Date: Wed, 20 Jan 2010 11:37:12 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/37] x86: move range related operation to one file
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-2-git-send-email-yinghai@kernel.org> <alpine.DEB.2.00.1001191048480.22304@router.home>
In-Reply-To: <alpine.DEB.2.00.1001191048480.22304@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 08:54 AM, Christoph Lameter wrote:
> 
> On Fri, 15 Jan 2010, Yinghai Lu wrote:
> 
> <need more text here describing f.e. how you changed the API and merged
> some functions doing similar work>
> 
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
>> -
>> -static int __init cmp_range(const void *x1, const void *x2)
>> -{
>> -	const struct res_range *r1 = x1;
>> -	const struct res_range *r2 = x2;
>> -	long start1, start2;
>> -
>> -	start1 = r1->start;
>> -	start2 = r2->start;
>> -
>> -	return start1 - start2;
>> -}
> 
> 
> Function is passed to sort() should not be used directly. Maybe add
> comments.
> 
>> -	static struct res_range range_new[RANGE_NUM];
>> +	static struct range range_new[RANGE_NUM];
> 
> Renaming res_range -> range. Good but explain.
> 
>> -	nr_range = add_range_with_merge(range, nr_range, 0,
>> +	nr_range = add_range_with_merge(range, RANGE_NUM, nr_range, 0,
>>  					(1ULL<<(20 - PAGE_SHIFT)) - 1);
> 
> add_range_with_merge semantics changed. Explain.
> 
>>  		update_res(info, start, end, IORESOURCE_IO, 1);
>> -		update_range(range, start, end);
>> +		subtract_range(range, RANGE_NUM, start, end);
> 
> Two functions merged?
> 
>> +void subtract_range(struct range *range, int az, u64 start, u64 end)
> 
> Subtract range can now do what update_range did? How so?

update_range was introduced at first. and actually it did sth like subtract range.

and subtract range is more accurate.

Yinghai
