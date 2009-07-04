Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZGDWn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZGDWn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 18:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZGDWnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 18:43:51 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:2845 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbZGDWnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 18:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vydghaYJZ7xeurV7T2IvtYxrrhFY8X6tQqUO020Qd1OpArzwPkP7jEpZrgHpWFw5dU
         07r2ws2Cyq17JNlBsUR0RLXP7bpWoVDP/uYtSWBu3HQbmkRaK/bVYhPc4lTOAwr4yl2F
         +7HeZ+IewpKjhbIWSP8KgbpwJjr2ixJoIjE7Q=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0906241521s23c0d3bes56398a3333d4ee57@mail.gmail.com>
References: <8bd0f97a0906231508s4c115d3dr2848626bc5a28c5e@mail.gmail.com> 
	<20090624131357.GA6224@elte.hu> <200906241602.38422.arnd@arndb.de> 
	<8bd0f97a0906240802ieec96fav2864fa199d3f1b90@mail.gmail.com> 
	<8bd0f97a0906241521s23c0d3bes56398a3333d4ee57@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 4 Jul 2009 18:43:34 -0400
Message-ID: <8bd0f97a0907041543w5f173e11vf358d5b36c0659b3@mail.gmail.com>
Subject: Re: PREEMPT_ACTIVE too low error with all asm-generic headers for 
	some arches
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 18:21, Mike Frysinger wrote:
> On Wed, Jun 24, 2009 at 11:02, Mike Frysinger wrote:
>> On Wed, Jun 24, 2009 at 10:02, Arnd Bergmann wrote:
>>> --- a/include/linux/hardirq.h
>>> +++ b/include/linux/hardirq.h
>>> @@ -62,6 +62,12 @@
>>>  #define HARDIRQ_OFFSET (1UL << HARDIRQ_SHIFT)
>>>  #define NMI_OFFSET     (1UL << NMI_SHIFT)
>>>
>>> +#ifndef PREEMPT_ACTIVE
>>> +#define PREEMPT_ACTIVE_BITS    1
>>> +#define PREEMPT_ACTIVE_SHIFT   (NMI_SHIFT + NMI_BITS)
>>> +#define PREEMPT_ACTIVE (__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_SHIFT)
>>
>> i think you meant "<< PREEMPT_ACTIVE_SHIFT" there.  once i make that
>> change, it builds fine.
>
> and like Ingo, with that fix, add my Acked-by
>
> thanks !

could you push this to Linus ?  or should i throw something into the
Blackfin headers in the meantime ?
-mike
