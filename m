Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYJVOR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYJVOR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYJVORM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:17:12 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:51378 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbYJVORK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:17:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dMLO9cDVi7KETqHm/wXK9xUCh/Bn008Y1p2KJe9MCgYZVz65Hdn8T5jbKpQNWCXCb3
         M+Vf+5ZlOElpeaWVg6OuLZF14460dre2BGE+zWohC2Xx5KigoyX8VEatQSLBpBqtnAKq
         1oZpCcTe5tGmzT294rJ70dt/Ds+BsR4LxDuoc=
Message-ID: <5d6222a80810220717u758b69a9x5bdbc32385c81c52@mail.gmail.com>
Date: Wed, 22 Oct 2008 12:17:07 -0200
From: "Glauber Costa" <glommer@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip] x86: do_boot_cpu - check if we have ESR register
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <20081022141354.GA26372@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081022140009.GA9639@localhost> <20081022141354.GA26372@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 12:13 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> We should touch ESR register if only we have it.
>> The patch fixes the problem mentoined here
>>
>>       http://lkml.org/lkml/2008/10/17/147
>>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>> CC: Glauber Costa <glommer@gmail.com>
>
>> -             apic_write(APIC_ESR, 0);
>> -             apic_read(APIC_ESR);
>> +             if (APIC_INTEGRATED(apic_version[phys_apicid])) {
>> +                     apic_write(APIC_ESR, 0);
>> +                     apic_read(APIC_ESR);
>> +             }
>
> i'm wondering - is the server there really that old, that it has no
> integrated lapic? I.e. it's an i486 SMP box or so? Or perhaps some
> other, weird SMP box?

It's a Xeon, so probably just weird.

>
>        Ingo
>



-- 
Glauber  Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
