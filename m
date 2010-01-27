Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526Ab0A0Px2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab0A0Px2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409Ab0A0Px1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:53:27 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:65104 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab0A0Px0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:53:26 -0500
Message-ID: <4B6060F2.3070702@vflare.org>
Date: Wed, 27 Jan 2010 21:21:14 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] use lock for 64-bit stats
References: <1264602246-12880-1-git-send-email-ngupta@vflare.org> <1264602246-12880-2-git-send-email-ngupta@vflare.org> <4B605779.9010500@cs.helsinki.fi>
In-Reply-To: <4B605779.9010500@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 08:40 PM, Pekka Enberg wrote:
> Nitin Gupta wrote:
>> +static void stat_dec(u32 *v)
>> +{
>> +    *v = *v - 1;
>> +}
>> +
>> +static void stat64_inc(struct ramzswap *rzs, u64 *v)
>> +{
>> +    spin_lock(&rzs->stat64_lock);
>> +    *v = *v + 1;
>> +    spin_unlock(&rzs->stat64_lock);
>> +}
>> +
>> +static void stat64_dec(struct ramzswap *rzs, u64 *v)
>> +{
>> +    spin_lock(&rzs->stat64_lock);
>> +    *v = *v - 1;
>> +    spin_unlock(&rzs->stat64_lock);
>> +}
>> +
>> +static u64 stat64_read(struct ramzswap *rzs, u64 *v)
>> +{
>> +    u64 val;
>> +
>> +    spin_lock(&rzs->stat64_lock);
>> +    val = *v;
>> +    spin_unlock(&rzs->stat64_lock);
>> +
>> +    return val;
>> +}
>> +#else
>> +#define stat_inc(v)
>> +#define stat_dec(v)
>> +#define stat64_inc(r, v)
>> +#define stat64_dec(r, v)
>> +#define stat64_read(r, v)
>> +#endif /* CONFIG_RAMZSWAP_STATS */
> 
> I think I complained about this before: the names are too generic and
> could collide with core kernel code. I think they ought to be called
> ramzsawp_stat*().
> 


I somehow missed this point. I will rename these to rzs_stat*()
('rzs_' prefix is used for other one-liner functions too).

Thanks,
Nitin
