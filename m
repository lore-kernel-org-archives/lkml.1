Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYFMS1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYFMS1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 14:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYFMS04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 14:26:56 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:10605 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYFMS0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 14:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oHw+A4dQ397a+JK1CTY60+rUg/gIutnYoEh4KBCUrD+Y5/c+2CNB0tmDh383mtTs+A
         uCf5Sa0hpSxXRhiuq1hKcPiD18shqtxnKMI1qmnOTtqXJPnpULrjihHbCdxIruiaRUTX
         AJmg0JYPkq784mSGpZRInkUgR15yn72l1va9s=
Message-ID: <5d6222a80806131126w593ca7c1t1a5b527329af0fe4@mail.gmail.com>
Date: Fri, 13 Jun 2008 15:26:53 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH 2/2] x86: Move PCI IO ECS code to x86/pci
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20080613181627.GH10019@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080603072550.GR23679@erda.amd.com>
	 <1213294763-19566-2-git-send-email-robert.richter@amd.com>
	 <5d6222a80806131002t4f5c6e54tee63d4ed0fc222a6@mail.gmail.com>
	 <20080613181627.GH10019@erda.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 3:16 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 13.06.08 14:02:46, Glauber Costa wrote:
>> > diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
>> > index 5c2799c..15f505d 100644
>> > --- a/arch/x86/pci/amd_bus.c
>> > +++ b/arch/x86/pci/amd_bus.c
>> > @@ -1,5 +1,9 @@
>> >  #include <linux/init.h>
>> >  #include <linux/pci.h>
>> > +#include "pci.h"
>> > +
>> > +#ifdef CONFIG_X86_64
>>
>> Please, don't do that. We are in an ongoing effort to cleanup the
>> remaining ifdefs in x86 code, and adding more of them would just make
>> it harder.
>> If you really need it, move the common part to a separate file (avoid
>> the _32 and _64 naming), and have it compiled conditionally on your
>> architecture.
>
> Ok, so what about shared code? Keep all this in separate files:
> amd_bus.c, (amd_bus_32.c), amd_bus_64.c, (amd_bus.h)?
>
> Is the strategy to avoid #ifdefs and instead use the flags in
> Makefiles? My intention was to coalesce the files. Maybe I was wrong
> here.

The strategy is to coalesce the files if they do the same thing. If
you can find an implementation that is shared
between both, it is surely the most preferable option among them all.
Even if it takes more time.

For some of them, this is obviously not intrinsically possible. That's
the case for example, of the .S files that touch deep details of the
architectures. (ok, ok, _some_ of that code might well be shared in
the future). Another example, is the page headers. Part of it
were kept in page_32.h and page_64.h.

If not, ifdefs in the .h file are probably okay, if they can be used
to avoid them in .c code.

But of course, those things are not carved in stone. If you really
think that ifdef should go there, feel free to do it, with a good
justification.

-- 
Glauber  Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
