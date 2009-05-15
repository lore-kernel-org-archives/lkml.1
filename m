Return-Path: <linux-kernel-owner+w=401wt.eu-S1760834AbZEOJ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbZEOJ2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 05:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757617AbZEOJ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 05:28:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:38156 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757487AbZEOJ2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 05:28:03 -0400
Message-ID: <4A0D357A.1070705@kernel.org>
Date: Fri, 15 May 2009 18:27:22 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, andi@firstfloor.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH 4/5] x86: implement percpu_alloc kernel parameter
References: <1242361739-21186-1-git-send-email-tj@kernel.org> <1242361739-21186-5-git-send-email-tj@kernel.org> <4A0D3E11020000780000109C@vpn.id2.novell.com>
In-Reply-To: <4A0D3E11020000780000109C@vpn.id2.novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 09:27:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Tejun Heo <tj@kernel.org> 15.05.09 06:28 >>>
>> @@ -395,6 +404,16 @@ out_free_ar:
>> 	return ret;
>> }
>>
>> +/* for explicit first chunk allocator selection */
>> +static char pcpu_chosen_alloc[16] __initdata;
>> +
>> +static int __init percpu_alloc_setup(char *str)
>> +{
>> +	strncpy(pcpu_chosen_alloc, str, sizeof(pcpu_chosen_alloc) - 1);
>> +	return 0;
>> +}
>> +early_param("percpu_alloc", percpu_alloc_setup);
>> +
>> static inline void setup_percpu_segment(int cpu)
>> {
>> #ifdef CONFIG_X86_32
> 
> Does this really need to be early_param()? setup_per_cpu_areas()
> runs after setup_arch(), which is where the full command line
> parsing happens.

__setup() callbacks ran after PERCPU allocation.  Confirmed with
printk.

Thanks.

-- 
tejun
