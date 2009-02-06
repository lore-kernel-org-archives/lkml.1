Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbZBFLL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbZBFLL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 06:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZBFLLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 06:11:45 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:60261 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbZBFLLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 06:11:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cQmszXDdnrqToWN17NWt/PIY04WGc7pWqaNTbhNQiUg/Q6CIyne/+Z8wd1oL9+iahZ
         Oy3bkn2lE6LVI8mTZUqw4ySBFLGv8erH9vS1wkywgNEz0+SvTdQOjKgINeQ84WEolQ6A
         OrSjqr1zMkRITW8TsGEU2noI1YsXz1Rbb9uC4=
MIME-Version: 1.0
In-Reply-To: <12c511ca0902051430w78ca10d9rf96804748ce6ea79@mail.gmail.com>
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
	 <1232326345-3534-1-git-send-email-brgerst@gmail.com>
	 <1232326345-3534-2-git-send-email-brgerst@gmail.com>
	 <12c511ca0902051430w78ca10d9rf96804748ce6ea79@mail.gmail.com>
Date: Fri, 6 Feb 2009 06:11:43 -0500
Message-ID: <73c1f2160902060311k4be188f5nd6a43d085d0c4e7d@mail.gmail.com>
Subject: Re: [PATCH 2/5] percpu: Refactor percpu.h
From: Brian Gerst <brgerst@gmail.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 5:30 PM, Tony Luck <tony.luck@intel.com> wrote:
> On Sun, Jan 18, 2009 at 4:52 PM, Brian Gerst <brgerst@gmail.com> wrote:
>> Refactor the DEFINE_PER_CPU_* macros and add .data.percpu.first
>> section.
>>
>> Signed-off-by: Brian Gerst <brgerst@gmail.com>
>
>> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
>> index 9f2a375..0e24202 100644
>> --- a/include/linux/percpu.h
>> +++ b/include/linux/percpu.h
> ...
>
>> +#define DEFINE_PER_CPU_SECTION(type, name, section)                    \
>> +       __attribute__((__section__(PER_CPU_BASE_SECTION section)))      \
>>        PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
>
> Brian,
>
> This causes errors for CONFIG_SMP=n builds on ia64.  If you look
> at arch/ia64/include/asm/percpu.h you'll see that the !SMP case has
>
>
> #define PER_CPU_ATTRIBUTES      __attribute__((__section__(".data.percpu")))
>
> So we end up with section attributes of both ".data" and
> ".data.percpu" for every
> DEFINE_PER_CPU used.  The compiler doesn't like that at all :-(
>
>
> Perhaps PER_CPU_BASE_SECTION needs to be defined by <asm/percpu.h>
> so ia64 can avoid the section conflict?
>
> -Tony
>

Why does IA64 still have a special percpu section on UP?  Is there a
particular reason why it can't degenerate to regular .data like every
other arch?

--
Brian Gerst
