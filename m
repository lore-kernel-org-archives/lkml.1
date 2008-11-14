Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbYKNSF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbYKNSF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbYKNSFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:05:40 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:63296 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbYKNSFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:05:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VSLLgoMAs4FL3Oa6n0C4fw05Es+i8QN4xdpWxBzgPNMMbAaoicUJU8TGC8KjGD30qj
         8ITQhPMxgXVyXY5TBdpBHNX61yjo+6oXomnG+gLchzdV5WrMIAmE1KLAoStEcwwov8+i
         ewZbE9oMCdtxBeqTyBPPpuJqTa/+zXSr1vyEM=
Message-ID: <491DBDEA.9010104@gmail.com>
Date: Fri, 14 Nov 2008 20:05:30 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
References: <s5h3ai11dpt.wl%tiwai@suse.de> <20081109151323.GA18705@rhlx01.hs-esslingen.de> <s5h7i7c916e.wl%tiwai@suse.de> <20081109200929.GA29333@rhlx01.hs-esslingen.de> <s5hiqqtkxqr.wl%tiwai@suse.de> <491B0D38.1050207@gmail.com> <20081112180519.GA21919@rhlx01.hs-esslingen.de>
In-Reply-To: <20081112180519.GA21919@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> Hi,
> 
> On Wed, Nov 12, 2008 at 07:07:04PM +0200, Maxim Levitsky wrote:
>> I pretty much studied the datasheet and driver, and this is what I found:
>> btw, my acer 5720 and aspire one share same ALC268.
>> Some stuff is trivially fixable, some seems to be unfixable at all:
> 
> Wow, what an extremely in-depth analysis!
> I just intended to dive into getting mic routing corrected myself,
> thus you saved me a lot of time!
> 
>> model=acer is used on my regular laptop.
>> model-acer-aspire is used on aspire one laptop, and it needs to be renamed, as both are aspire.
> 
> +1 (your analysis of both being rather different - as already pondered -
> confirms this necessity)
> 
>> And now for unfixable problems:
>>
>> 1) There is strong DC offset on all inputs.
>> it is even different on left/right and depends on capture volume.
>> I tried to change the VREF only param that could help, but it doesn't.
>> I feel that this is hardware flaw.
>> (It is possible that voltage on inputs is created by circuit made by acer, and then ALC268 amplifies it.)
> 
> Sounds like really bad circuit design then.
> One would think that the Intel HDA architecture might have builtin
> measures to compensate for this if needed? DC offset issues on
> soundcards aren't exactly a new phenomenon after all...
> 
>> Lastly I noticed that datasheet mentions so called 'coefficients':
>> the codecs exposes lots of internal and undocumented registers using set address/ get/set value scheme.
>> maybe some of above bugs are fixable there, but ether realtek has to provide data for that or reverse engineering of
>> windows driver is required.
> 
> I've actually had a peek at the .inf files since I thought that it would
> already contain register values in those registry keys that it creates on
> install, but yeah, that's all in-driver it seems.
> Probably time to ask Acer about specifics, especially since I didn't spot
> any hda-intel changes in their linux-2.6.23.9lw source.
> 
> Thank you very much,
> 
> Andreas Mohr

Small update:

1) The dc offset isn't present on aspire one, really is a circuit design bug I guess 
2) Internal mic works perfectly on aspire one, can reproduce the strange behaver at all,
Probably this was mixer bug.

So aspire one support is almost, only need to add support to restore beep volume
after resume.


Best regards,
	Maxim Levitsky


