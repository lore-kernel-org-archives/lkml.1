Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296Ab0CMPPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 10:15:07 -0500
Received: from mail.tpi.com ([70.99.223.143]:2961 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759242Ab0CMPPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 10:15:04 -0500
X-Greylist: delayed 2080 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Mar 2010 10:15:04 EST
Message-ID: <4B9BA3C3.50403@canonical.com>
Date: Sat, 13 Mar 2010 07:40:03 -0700
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100222 Thunderbird/3.0.1
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Patrick McHardy <kaber@trash.net>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [104/145] netfilter: xt_recent: fix false match
References: <20100313002816.GA18903@kroah.com> <20100313002714.299272135@kvm.kroah.org> <20100313062446.GG12342@1wt.eu>
In-Reply-To: <20100313062446.GG12342@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2010 11:24 PM, Willy Tarreau wrote:
> On Fri, Mar 12, 2010 at 04:27:17PM -0800, Greg KH wrote:
>> 2.6.32-stable review patch.  If anyone has any objections, please let me know.
>>
>> ----------------
>> From: Tim Gardner<tim.gardner@canonical.com>
>>
>> commit 8ccb92ad41cb311e52ad1b1fe77992c7f47a3b63 upstream.
>>
>> A rule with a zero hit_count will always match.
>>
>> Signed-off-by: Tim Gardner<tim.gardner@canonical.com>
>> Signed-off-by: Patrick McHardy<kaber@trash.net>
>> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
>>
>> ---
>>   net/netfilter/xt_recent.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- a/net/netfilter/xt_recent.c
>> +++ b/net/netfilter/xt_recent.c
>> @@ -260,7 +260,7 @@ recent_mt(const struct sk_buff *skb, con
>>   		for (i = 0; i<  e->nstamps; i++) {
>>   			if (info->seconds&&  time_after(time, e->stamps[i]))
>>   				continue;
>> -			if (++hits>= info->hit_count) {
>> +			if (info->hit_count&&  ++hits>= info->hit_count) {
>>   				ret = !ret;
>>   				break;
>>   			}
>
> I don't know if this has any undesired side effect or not, but the
> logic is changed now since "hits" will not be increased anymore when
> info->hit_count is zero. And the code does not make it obvious to me
> what the intended purpose was.
>
> For this reason I always find it dangerous to change variables in
> if() conditions because it's where we change operations the most
> frequently when fixing bugs.
>
> Willy
>

Willy - I agree with you that changing variables in an if() clause can 
be dangerous. I did consider the possibility for side effects in this 
case, but decided to go with the simplest patch since 'hits' is local to 
the scope of the the surrounding else if() clause and is used in no 
other place.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
