Return-Path: <linux-kernel-owner+w=401wt.eu-S1762647AbZLLAns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647AbZLLAns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761528AbZLLAnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:43:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:60663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761512AbZLLAno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:43:44 -0500
Message-ID: <4B22E6F8.2030801@kernel.org>
Date: Fri, 11 Dec 2009 16:42:32 -0800
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
Subject: Re: [PATCH 5/7] x86/pci: use u64 instead of size_t in amd_bus.c
References: <4B22D4DA.2000104@kernel.org> <4B22D746.9040807@kernel.org> <4B22DBEB.6090407@zytor.com>
In-Reply-To: <4B22DBEB.6090407@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 12/11/2009 03:35 PM, Yinghai Lu wrote:
>>
>> prepare to enable it for 32bit
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/pci/amd_bus.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/arch/x86/pci/amd_bus.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/pci/amd_bus.c
>> +++ linux-2.6/arch/x86/pci/amd_bus.c
>> @@ -82,8 +82,8 @@ static int __init early_fill_mp_bus_info
>>  	struct pci_root_info *info;
>>  	u32 reg;
>>  	struct resource *res;
>> -	size_t start;
>> -	size_t end;
>> +	u64 start;
>> +	u64 end;
>>  	struct range range[RANGE_NUM];
>>  	u64 val;
>>  	u32 address;
>>
> 
> Shouldn't this be resource_size_t?

it seems we should use u64, and check the if the sizeof(resource_size_t) != sizeof(u64)
and cap some vale.

YH
