Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092Ab0A2Rhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0A2Rhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007Ab0A2Rhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:37:36 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:53488 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab0A2Rhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:37:35 -0500
Message-ID: <4B631C7E.1080101@oracle.com>
Date: Fri, 29 Jan 2010 09:35:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-01-28-01-36 uploaded (sched.c + percpu)
References: <201001281002.o0SA2G0k002220@imap1.linux-foundation.org> <4B61DD8F.6020507@oracle.com> <20100128234125.GH2996@kryten>
In-Reply-To: <20100128234125.GH2996@kryten>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B631C99.01AE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/10 15:41, Anton Blanchard wrote:
>
> Hi Randy,
>
>> when CONFIG_SMP is not enabled:
>>
>> kernel/sched.c:10915: error: 'percpu_counter_batch' undeclared (first use in this function)
>
> Did 1/2 make it into mmotm?

I only see one patch from you in mmotm.


> Anton
>
> ---
>
> [PATCH 1/2] percpu_counter: Make __percpu_counter_add an inline function on UP
>
> Even though batch isn't used on UP, we may want to pass one in to keep the
> SMP and UP code paths similar. Convert __percpu_counter_add to an inline
> function so we wont get variable unused warnings if we do.
>
> Signed-off-by: Anton Blanchard<anton@samba.org>
> ---
>
> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> index a7684a5..794662b 100644
> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -98,9 +98,6 @@ static inline void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
>   	fbc->count = amount;
>   }
>
> -#define __percpu_counter_add(fbc, amount, batch) \
> -	percpu_counter_add(fbc, amount)
> -
>   static inline void
>   percpu_counter_add(struct percpu_counter *fbc, s64 amount)
>   {
> @@ -109,6 +106,12 @@ percpu_counter_add(struct percpu_counter *fbc, s64 amount)
>   	preempt_enable();
>   }
>
> +static inline void
> +__percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
> +{
> +	percpu_counter_add(fbc, amount);
> +}
> +
>   static inline s64 percpu_counter_read(struct percpu_counter *fbc)
>   {
>   	return fbc->count;
>


-- 
~Randy
