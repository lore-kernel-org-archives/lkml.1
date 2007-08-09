Return-Path: <linux-kernel-owner+w=401wt.eu-S938875AbXHIMHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938875AbXHIMHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762898AbXHIMHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:07:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46422 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762136AbXHIMHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:07:04 -0400
Message-ID: <46BB0337.6040701@sgi.com>
Date: Thu, 09 Aug 2007 14:06:15 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070719)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Carsten Otte <cotte@de.ibm.com>
Subject: Re: [PATCH 2/7] Added generic lg.h in lguest directory.
References: <20070809003211.373543702@goodmis.org>	 <20070809003343.310187242@goodmis.org> <5d6222a80708081756r21bbc7e3ifd357c9c548ac57f@mail.gmail.com>
In-Reply-To: <5d6222a80708081756r21bbc7e3ifd357c9c548ac57f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> On 8/8/07, Steven Rostedt <rostedt@goodmis.org> wrote:
>> Add a generic lg.h file to call the architecture specific one.
>>
>> diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
>> new file mode 100644
>> index 0000000..4c4356e
>> --- /dev/null
>> +++ b/drivers/lguest/lg.h
>> @@ -0,0 +1,3 @@
>> +#ifdef CONFIG_X86_32
>> +#include "i386/lg.h"
>> +#endif
> 
> Wouldn't it be cleaner to do something like the asm/ includes?
> I understand that lguest now lives in drivers/ and so we don't put
> headers directly in asm-i386 , but we could come up with a similar
> thing here. 

Yeah, that would be much better, and I don't like having something in
a header file including arch specific files like that. I target to get
lguest going on non x86, so I would like to encourage anyone to think
more than x86 when trying to seperate out something :)

IMHO we should avoid any header files with asm specific code in
drivers/lguest - in a way I prefer having arch/<foo>/lguest to
drivers/lguest/<arch>, would be more esthetically compliant with
the include/asm-<arch> approach too, but thats not a big deal.

Cheers,
Jes
