Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYGHLi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYGHLi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 07:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbYGHLit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 07:38:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:54235 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbYGHLis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 07:38:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s5t9M0SIadZNWeNHm+G9BRAFhSoeYH3k5K5nxCam5FQMOdXO6TucogVKHhUsGJHYCU
         M2OJ3pXfnlVsv958ectAsdz090m38l8F0hutSxeVU/HDsohnCbQyvqfWfibWo7m9sqvM
         yT9gz+fBZMLLTLk9h1Qs9N5Ab7k2qpNUYxTBs=
Message-ID: <aa79d98a0807080438u19fc4915sd81c9fedf8b90260@mail.gmail.com>
Date: Tue, 8 Jul 2008 15:38:45 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [Q] Is 64bit LVTT screwed
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0807072243410.20615@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080702184024.GC7003@cvg>
	 <Pine.LNX.4.55.0807072243410.20615@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2008 at 2:08 AM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
[...]
>>
>> but in both cases we use "divide by 16" in divide register. The only
>> explanation I imagine - for 64bit mode we are required to 'stuck'
>> for a bit longer (by 16 times longer to be precise). Am I right?
>> Or there is another reason why we dont use APIC_DIVISOR here. Actually,
>> as I see it not fair to a caller. For 64bit mode APIC timer is requested
>> to count 250000000 ticks but in real it will count 250000000 * 16.
>> Not sure who is right there. I think the better would be to
>> use 4000000000 and APIC_DIVISOR in 64bit mode. How do you think?
>
>  The APIC clock varies across systems so the timer setup includes
> calibration.  Which means both variations end up with the correct
> interrupt rate probably, except using different divisors.  We used to
> print the APIC clock rate and that would be off with one of the above, but
> I don't we do this anymore.  We had a similar problem with the 82489DX
> where the prescaler was bypassed altogether resulting in an incorrect
> clock rate printed, but the rate of timer interrupt was correctly
> calibrated regardless.
>
>  This is of course merely an explanation why the code you quoted does not
> explode spectacularly.  It does not make it correct.  If the prescaler is
> indeed set to 16 for 64-bit systems, then APIC_DIVISOR should obviously be
> used in the calculation above too.  And if not, then I think the prescaler
> should be set consistently across systems and then the setting reflected
> in the calculations accordingly.  Please note that only values between 2
> and 16 are supported in a uniform way across all the APIC models and using
> low values risks an overflow as clock rates are in the GHz range these
> days already.  The value of 16 seems a reasonable one.
>
>  Maciej
>

Thanks, Maciej, for explanation. Unfortunelly I'm quite busy now so
I stopped merging/research on apic code, as only get spare time - will
let you know my results.

- Cyrill -
