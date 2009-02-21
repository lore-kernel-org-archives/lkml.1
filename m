Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZBUDXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZBUDXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 22:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbZBUDXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 22:23:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:49252 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbZBUDXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:23:47 -0500
Message-ID: <499F73BD.4030105@kernel.org>
Date: Sat, 21 Feb 2009 12:23:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH UPDATED 09/10] percpu: implement new dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org>	<1234958676-27618-10-git-send-email-tj@kernel.org>	<499E5BF9.1060806@kernel.org> <20090220003743.d787107b.akpm@linux-foundation.org>
In-Reply-To: <20090220003743.d787107b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Feb 2009 03:23:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> +void *pcpu_base_addr;
>> +EXPORT_SYMBOL_GPL(pcpu_base_addr);
>> +
>> +/* the size of kernel static area */
>> +static int pcpu_static_size;
> 
> It would be nice to document the units of the `size' variables.  Bytes?
> Pages?

I almost always use size for bytes, so it isn't confusing to me.

> Or, better: s/size/bytes/g.  
>
>> +static int pcpu_size_to_slot(int size)
>> +{
>> +	int highbit = fls(size);
>> +	return max(highbit - PCPU_SLOT_BASE_SHIFT + 2, 1);
>> +}
> 
> See,
> 
> static int pcpu_bytes_to_slot(int bytes)
> {
> 	int highbit = fls(bytes);
> 	return max(highbit - PCPU_SLOT_BASE_SHIFT + 2, 1);
> }
> 
> is clearer.

but, yeah, I agree.  I'll post a patch to do the renaming.

Thanks.

-- 
tejun
