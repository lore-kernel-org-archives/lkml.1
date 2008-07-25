Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYGYNA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYGYNA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 09:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYGYNAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 09:00:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:32720 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYGYNAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hn0NOgOOZfq0u7tRl3Qd6Qd1mIQsMWg3KhsCsH8SLiIcWBO20MlIR1pxDLoHojHA0Y
         WZs4zd/VUD10uAi2nyQPxOD4BQR3+ozoSh90T1FY/G4uOyZLchKwcuOQCmxK83BhKjdA
         lGlkb47F507Tl10CgHoE8HloTPCVT8O2QeFqs=
Date: Fri, 25 Jul 2008 16:59:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take 2)
Message-ID: <20080725125950.GA28466@lenovo>
References: <20080724111631.GA3432@lenovo> <48886E6D.1030005@fujitsu-siemens.com> <20080724120512.GA21804@lenovo> <488889B6.9070707@fujitsu-siemens.com> <20080724143151.GA32422@lenovo> <20080724150116.GC32422@lenovo> <48889C14.4070408@fujitsu-siemens.com> <4889968E.6020000@fujitsu-siemens.com> <20080725100844.GA16698@lenovo> <4889C723.7050402@fujitsu-siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4889C723.7050402@fujitsu-siemens.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Martin Wilck - Fri, Jul 25, 2008 at 02:29:23PM +0200]
> Cyrill Gorcunov wrote:
>
>> Hi Martin, what about the patch below - I simplified it a bit.
>> Actually we have to handle 32bit mode as well I think.
>
> Yes.
>
>> Anyway,
>> take a look. I don't really mind against your patch but we better
>> should wait until Maciej could take a look (he will be able in
>> a week or maybe a bit later).
>>
>
>> +       for (i = 0; i < MAX_ITER; i++) {
>> +               rdtscll(tsc0);
>> +               *apic = apic_read(APIC_TMCCT);
>> +               rdtscll(tsc1);
>> +               diff = tsc1 - tsc0;
>> +               if (diff < MAX_DIFFERENCE) {
>> +                       *tsc = tsc0 + diff / 2;
>> +                       return 0;
>> +               }
>> +       }
> > +
> > +       return -EIO ;
>
> This is wrong - you need to set *tsc also in the -EIO case, otherwise  
> the function can return total bogus.

indeed, thanks! that is not the only problem - I also initialized 'i'
twice :)

>
> I have to say that my simplified patch failed to do the calibration  
> correctly on our test system (the original patch worked well). Please  
> stay tuned, we are investigating this currently.
>
> Martin
>

ok, Martin, I'm leaving for vacation soon - hope someone else could
take a look :)

		- Cyrill -
