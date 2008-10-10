Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYJJLQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYJJLQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbYJJLQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:16:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:41910 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806AbYJJLQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:16:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dJx8YWliKIDKM7VUTkMXsn2yYDW08CpDFzP6TUCrsuPplqakln7egs2oylANN2poKG
         DHXDK7bGZb4NtMoZ5p9KqLvVWBOfTHHkFGScmH72e0pOR8qqEP9+3WJ2eVFDWJ6bPOEU
         qYoBv4AH5E4eJ1rN8c0J9EiTPEoa5SCNwW0is=
Message-ID: <aa79d98a0810100416q72ec10d5q7d841e02dc4d4f81@mail.gmail.com>
Date: Fri, 10 Oct 2008 15:16:32 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] Typo in x86 apic.c with DIVISOR setup
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081010090100.GC319@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081010002203.GA23238@linux-os.sc.intel.com>
	 <aa79d98a0810092138q1f27a94bhd544ca3637c02c4f@mail.gmail.com>
	 <7E82351C108FA840AB1866AC776AEC463782339F@orsmsx505.amr.corp.intel.com>
	 <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com>
	 <20081010090100.GC319@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 1:01 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> Ah, it was CONFG who is guilty :) This is true indeed, thanks!
>
> yeah.
>
>> But here is not the same
>>
>>        apic_write(APIC_TDCR,
>>                (tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
>> -               APIC_TDR_DIV_16);
>> +               APIC_TDR_DIV);
>>
>> On x86_64 it will be 1 now but we've used 16 for a long time in
>> purpose to slowdown processor's bus CLKs from APIC point of view. So I
>> don't think it's good idea to change it now. If we start using divisor
>> 1 today -- it would work for some time 'till processor bus raised to
>> the some speed when we'll get counter underflow before calibration
>> finished.
>>
>> So could you please split the patch into two:
>> 1) Plain CONFG typo fix (which is completely Ack'ed)
>> 2) APIC divisor patch (which I'm not sure if we've to touch)
>
> okay, since we typoed that CONFG thing (sidenote: we really need a
> .config flag that will start a grep that fails the build if there's a
> non-existent CONFIG option anywhere in the tree), we basically tested
> the divisor of 16 on a wide range of boxes.
>
> So .. how about just standardizing on the divisor of 16 on both 32-bit
> and 64-bit?
>
>        Ingo
>

Btw I don't remember but hope it was not me who made this typo --
I've been trying to bring into kernel CONFIX variable one day (which
was typo too) :-)
