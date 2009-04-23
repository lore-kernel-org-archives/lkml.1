Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbZDWQRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbZDWQRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZDWQQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:16:55 -0400
Received: from mx1.emlix.com ([193.175.82.87]:34355 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbZDWQQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:16:55 -0400
Message-ID: <49F09472.2040206@emlix.com>
Date: Thu, 23 Apr 2009 18:16:50 +0200
From: =?UTF-8?B?RGFuaWVsIEdsw7Zja25lcg==?= <dg@emlix.com>
Organization: emlix GmbH
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Chris Zankel <chris@zankel.net>
CC: Johannes Weiner <jw@emlix.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 09/12] xtensa: allow platform and variant to initialize
 own irq chips
References: <1239702080-14355-1-git-send-email-jw@emlix.com> <1239702080-14355-10-git-send-email-jw@emlix.com> <49F0166B.9060006@zankel.net>
In-Reply-To: <49F0166B.9060006@zankel.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/23/2009 09:19 AM, Chris Zankel wrote:
>> -#ifdef CONFIG_VARIANT_IRQ_SWITCH
>>  #include <variant/irq.h>
>> -#else
>> +#ifndef CONFIG_VARIANT_IRQ_SWITCH
>>  static inline void variant_irq_enable(unsigned int irq) { }
>>  static inline void variant_irq_disable(unsigned int irq) { }
>>  #endif
> 
> What was the reason for this change? We shouldn't require all processor
> variants to provide an irq.h header file, unless required (and we
> wouldn't need to add the following files)

Let me quote a few more lines of that hunk:

>>
>> +#ifndef VARIANT_NR_IRQS
>> +# define VARIANT_NR_IRQS 0
>> +#endif

Where can a variant define VARIANT_NR_IRQS if not inside a new header?
Do you prefer it being defined in core.h, tie.h, or tie-asm.h?

I think this boils down to the restructuring necessary in arch/xtensa that will
draw a line between the Xtensa core and a SoC featuring that core (as it was
described by Marc on March 31 on the linux-xtensa list). Of course a "core" will
never need any IRQs beyond XTENSA_NR_IRQS.

Another possibility would be to select VARIANT_IRQ_SWITCH (or a dedicated new
Kconfig option) in all SoCs that need additional IRQs.

  Daniel

-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Geschäftsführung: Dr. Uwe Kracke, Dr. Cord Seele, Ust-IdNr.: DE 205 198 055
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160

emlix - your embedded linux partner
