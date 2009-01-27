Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZA0LrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZA0LrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZA0LrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:47:11 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:61861 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZA0LrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:47:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EZQq7r+9YUSmOA28Sucuhg9gZ4BaXCc/W8FSVPn9aszBAONeFAtT8F162R4iLKpYuS
         x9Q9eo5F1zfMqYEJPSzg+rgjMdkTAau5E0elUe5mGYwR1E6GTxxulZeHaPoUeL5CxzXN
         UezuPHMmLjr4Ef0xVm4MoBxofawuao/tHpEiw=
Message-ID: <497EF43D.9010303@gmail.com>
Date: Tue, 27 Jan 2009 20:47:09 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 #tj-percpu] x86: fix build breakage on voyage
References: <20090126103243.GA31307@elte.hu> <1232977445-11815-1-git-send-email-brgerst@gmail.com> <20090126141832.GA31442@elte.hu> <497E6B34.1020508@kernel.org> <497E8778.9060503@gmail.com> <1233032609.3248.78.camel@localhost.localdomain> <497E9B9D.4010102@gmail.com> <20090127113734.GA28249@elte.hu>
In-Reply-To: <20090127113734.GA28249@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
>> +#ifdef CONFIG_X86_LOCAL_APIC
>>  	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
>>  	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
>> +#endif
> 
> That patch is not acceptable - it is ugly and it adds another set of
> #ifdefs to an already complex piece of code.

Well, although the patch itself does add #ifdef, if you look over the
whole series, voyager is now a much more conforming citizen in the x86
world.  There are several solutions to this particular one.

1. Just let apic stuff defined and not use it in voyager if the ifdef
   is disturbing.  IIUC, apic isn't used in voyager at all, right?

2. Clean up early percpu stuff so that it each early percpu variable
   doesn't need to be explicitly copied and cleared, which is the
   actual problem here.

3. But, then again, the current interim and ugly way of doing it isn't
   too bad considering the small number of early per cpu users.

To me the current form doesn't look too bad but if it's too ugly,
maybe doing #2 is not such a bad idea such that early percpu can be
transferred to percpu in more systematic way.  It still feels a bit
like overdoing it tho.

What do you think?

Thanks.

-- 
tejun
