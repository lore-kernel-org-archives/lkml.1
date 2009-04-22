Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbZDVKdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbZDVKdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbZDVKdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:33:07 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63976 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZDVKdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:33:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cRq+sl1nV8B4wVcBaxmYxoH6noVU2KUcW1YX2PXg3p4IxrRyyz4McgV3LKdWVJT1tR
         EYi/e6Os0F7jI+L8nEEhPRN6Y+FxviSdhS5eLTe1yzWE+dSG/dTvdR2AoJEW1VBSOuGP
         6vk9vrTlWN1o1kXeZT1OlvaKBcM/DD6UfIBx8=
MIME-Version: 1.0
In-Reply-To: <20090422101811.GA1115@elte.hu>
References: <1240258569.6195.8.camel@earth> <1240344440.5861.10.camel@earth>
	 <20090422101811.GA1115@elte.hu>
Date: Wed, 22 Apr 2009 12:33:03 +0200
Message-ID: <b647ffbd0904220333n7bf7c35sdbdcec036963fa75@mail.gmail.com>
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the 
	synchronization logic
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/22 Ingo Molnar <mingo@elte.hu>:
>
> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>
>> +static long collect_cpu_info_local(void *arg)
>> +{
>> +     struct collect_for_cpu *cfc = arg;
>> +
>> +     BUG_ON(cfc->cpu != raw_smp_processor_id());
>> +
>> +     return microcode_ops->collect_cpu_info(cfc->cpu, cfc->cpu_sig);
>> +}
>> +
>> +static int collect_cpu_info_on_target(int cpu, struct cpu_signature *cpu_sig)
>> +{
>> +     struct collect_for_cpu cfc = { .cpu_sig = cpu_sig, .cpu = cpu };
>> +
>> +     return work_on_cpu(cpu, collect_cpu_info_local, &cfc);
>> +}
>
> Couldnt this be done without work_on_cpu(), by using
> smp_call_function()?

It should be definitely possible. Will send an updated version.

p.s. grrr... this idea should have come into my mind in the first place :-/


>
>        Ingo
>

-- 
Best regards,
Dmitry Adamushko
