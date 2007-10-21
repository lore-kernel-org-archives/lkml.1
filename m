Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbXJUMjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbXJUMjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 08:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXJUMjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 08:39:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:14373 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbXJUMjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 08:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=pXFgYh/4bFQfHxT7p+mNWUfrbWNpvgxYH93w6BNDBeXIMYF+Mp5AOSXRYqmKGHsEusv2voaODPBLoPQTliZoekCDwIET1b5lFZWXVPYiO/HoiALmPeXoxHPe8YfWjDrAFoItvQAua896SgkXqdzhRjO3hm22atvJ0XOqaIbLY1I=
Message-ID: <471B487C.5080209@googlemail.com>
Date: Sun, 21 Oct 2007 14:39:24 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: some kernel headers broken in current git ?
References: <4719174A.7020004@googlemail.com> <471AD5AD.9030000@zytor.com> <471B2918.5090502@googlemail.com>
In-Reply-To: <471B2918.5090502@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> BITS_PER_LONG was originally set in <asm/types.h>:
>>
>>      39  #ifdef CONFIG_X86_32
>>      40  # define BITS_PER_LONG 32
>>      41  #else
>>      42  # define BITS_PER_LONG 64
>>      43  #endif
> 
> User land does not know anything about 'CONFIG_X86_32' right ?

That is the problem. I've changed the headers virtualbox need from 

#ifdef CONFIG_X86_32 to #ifdef __i386__ and all compiled fine. 

( subarch headers includes are changed manually still but I think it is the same problem )

Also all the headers got these defines with CONFIG_X86_32 does not work.

...

#ifdef CONFIG_X86_32
# include "foo_32.h"
#else
# include "foo_64.h"
#endif

...

results in including both header files on my i686 box.

I don't know what the right way is to fix that , define some who CONFIG_X86_32 to __i386__ ? or just s/CONFIG_X86_32/__i386__/ ?


Gabriel
