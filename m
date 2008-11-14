Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbYKNKnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbYKNKnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 05:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYKNKnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 05:43:14 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:34601 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbYKNKnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 05:43:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Efb/YOxo7f6ULjSY3uCsczgDEVvQf8TG/8+Zak+b81ql0Idu0X6p3vWqFzXrMjfHIE
         BsiZxi9bxp/lCOA12ZywZKX0+awPZqlBy7mLIPmnq7qR6dcy1zlLWN1ygh5Tl80GavLn
         PcR0sXoTRnmlkMUlLFRLujbSmF16lJRQFzL9A=
Message-ID: <9ea470500811140243q242082b4i3864bdeb19301635@mail.gmail.com>
Date: Fri, 14 Nov 2008 11:43:12 +0100
From: "Borislav Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Wolfram Sang" <w.sang@pengutronix.de>
Subject: Re: [PATCH][RESEND] checkpatch: Add warning for p0-patches
Cc: "Andy Whitcroft" <apw@shadowen.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081114093853.GA3152@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225467370-19143-1-git-send-email-w.sang@pengutronix.de>
	 <20081112135522.GD8302@shadowen.org>
	 <9ea470500811120623q4334f840t4540649edba935@mail.gmail.com>
	 <20081113225540.GA11912@pengutronix.de>
	 <20081114064919.GB29121@gollum.tnic>
	 <20081114093853.GA3152@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Fri, Nov 14, 2008 at 10:38 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> Hi Boris,
>
>> --- /dev/null   2008-11-09 02:46:02.525014459 +0100
>> +++ arch/x86/kernel/tsc_resync.c        2008-11-14 07:22:34.000000000 +0100
>> @@ -0,0 +1 @@
>> +This is a new file
>>
>> and, as you can see, it is a -p0 patch. Now, in the code you do:
>>
>> if ($tree && -e "$root/$p1_prefix") {
>>       WARN("Patch prefix '$p1_prefix' exists. Is it maybe a p0-patch?\n");
>>
>> and the "$root/$p1_prefix" won't exist - as a matter of fact - would
>> lose its "arch" part due to the regex before and the if-condition won't
>> trigger.
>
> Careful. My approach is a bit different (inverse so to say) from yours
> which I missed back then. $p1_prefix is the part which _was_ cut off and
> it is wrong if it _does_ exist. See:
>
> -                       $realfile =~ s@^[^/]*/@@;
> +                       $realfile =~ s@^([^/]*)/@@;
> +
> +                       $p1_prefix = $1;

Doh, of course. I _did_ misinterpret the $p1_prefix, sorry. I was too
concentrated on the $realfile mangling.

> (So, a way to fool this algorithm is to give your kernel root dir the
> same name as a directory inside the root dir, like:
>
> --- drivers.orig/drivers/...
> +++ drivers/drivers/...
>
> This will generate a false positive. Oh, well...)
>
> I decided to go this way intentionally to handle the new file problem.
> So, in your case (I tried) it will cut off "arch", find the "arch"
> directory and will complain. (Did you actually apply this patch? ;))
>
> I thought the variable name 'p1_prefix' would speak for itself, but as
> you misinterpreted it, maybe it should be renamed?

No, keep it that way, for others who _can_ read, unlike me :).

-- 
Regards/Gruss,
Boris
