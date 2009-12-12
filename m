Return-Path: <linux-kernel-owner+w=401wt.eu-S933891AbZLLCVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891AbZLLCVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 21:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932897AbZLLCVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 21:21:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:51393 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012AbZLLCVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 21:21:31 -0500
Message-ID: <4B22FDEF.5050600@kernel.org>
Date: Fri, 11 Dec 2009 18:20:31 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 61/7] x86/pci: add cap_4g
References: <4B22D4DA.2000104@kernel.org> <4B22D74D.4020201@kernel.org> <4B22FBEB.7040204@kernel.org> <4B22FD0B.10506@zytor.com>
In-Reply-To: <4B22FD0B.10506@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 12/11/2009 06:11 PM, Yinghai Lu wrote:
>>  
>> +static inline u64 cap_4g(u64 val)
>> +{
>> +	if (sizeof(resource_size_t) >= sizeof(u64))
>> +		return val;
>> +
>> +	if (val < 1ULL)
>> +		return val;
>> +
>> +	return 0xffffffff;
>> +}
>>  #endif
> 
> How about:
> 
> static inline resource_size_t cap_resource(u64 val)
> {
> 	if (val > ~(resource_size_t)0)
> 		return ~(resource_size_t)0;
> 	else
> 		return val;
> }

ok
