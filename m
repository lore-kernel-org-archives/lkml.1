Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZHZR2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZHZR2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZHZR2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:28:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZHZR2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:28:21 -0400
Message-ID: <4A957073.10302@zytor.com>
Date: Wed, 26 Aug 2009 10:27:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jiri Slaby <jirislaby@gmail.com>, jeremy@xensource.com,
       chrisw@sous-sol.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] XEN: enlighten, use uninitialized_var(cx)
References: <1251234044-6943-1-git-send-email-jirislaby@gmail.com> <20090826060925.GA6194@elte.hu>
In-Reply-To: <20090826060925.GA6194@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2009 11:09 PM, Ingo Molnar wrote:
>>
>> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
>> index e90540a..5ab75e2 100644
>> --- a/arch/x86/xen/enlighten.c
>> +++ b/arch/x86/xen/enlighten.c
>> @@ -202,7 +202,7 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
>>  
>>  static __init void xen_init_cpuid_mask(void)
>>  {
>> -	unsigned int ax, bx, cx, dx;
>> +	unsigned int ax, bx, uninitialized_var(cx), dx;
> 
> Please dont use uninitialized_var(), it's an unreliable facility: if 
> this variable ever grows a real used-without-initialization bug in 
> the future, the compiler warning is turned off permanently. It's 
> rare but might happen. We are better off with initializing it to 
> zero.
> 

I hadn't seen this thread, but I pushed a patch to x86/urgent to do
exactly that while I was committing the Xen crash patch last night.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

