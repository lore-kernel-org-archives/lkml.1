Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZJSODR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZJSODR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbZJSODQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:03:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:34616 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbZJSODP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U8m4yyqPAMOqTjvViWmb9ABK86zaHtpZUw3b+5BqnwrNerPX2Vqt4io11u78zhNXh9
         rST2VekX/NRs1N3oiGZoFnUlLfi/ggPLxw4e1ERp+j/DmOK+M+7UIWqe8tZuFFD9cYoB
         EeQn+F4a6RkukeSRq0ZhrfR1hTsikF7oD9xfc=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0910190956580.3899-100000@iolanthe.rowland.org>
References: <94a0d4530910181609u33955cd5tf9e56b7d2ae9a616@mail.gmail.com>
	 <Pine.LNX.4.44L0.0910190956580.3899-100000@iolanthe.rowland.org>
Date: Mon, 19 Oct 2009 17:03:18 +0300
Message-ID: <94a0d4530910190703q1a0e2a6ar4cf74a68d7bc339f@mail.gmail.com>
Subject: Re: [PATCH 1/7] usb: trivial cleanups
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 4:59 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 19 Oct 2009, Felipe Contreras wrote:
>
>> I still have an unfixed warning:
>> drivers/usb/core/hcd.c: In function ‘rh_string’:
>> /data/public/src/linux/arch/x86/include/asm/string_32.h:74: warning:
>> array subscript is above array bounds
>>
>> Apparently there's a problem with the optimized memcpy for x86 with this code:
>> static char const langids[4] = {4, USB_DT_STRING, 0x09, 0x04};
>> len = min_t(unsigned, len, sizeof(langids));
>> memcpy(data, langids, len);
>> return len;
>>
>> gcc 4.4 is trying to optimize the memcpy, but it's not able to realize
>> that 'len' will always be <= 4 and the memcpy will not exceed langids.
>> One way to solve this is by replacing len with the min_t expression:
>> memcpy(data, langids, min_t(unsigned, len, sizeof(langids)));
>>
>> However, that looks ugly and we need the expression again for the
>> return. Another way is to remove 'const' from langids.
>>
>> AFAIK the code is perfectly correct as it is, I think the fact that
>> gcc 4.4 complains is a bug on gcc side.
>
> Yes, it is a well-known bug in gcc.  Other places in the kernel get
> similar warnings.

So gcc guys are aware of this? Is there a bug report or something?

-- 
Felipe Contreras
