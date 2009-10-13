Return-Path: <linux-kernel-owner+w=401wt.eu-S1759588AbZJMLwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588AbZJMLwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 07:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759551AbZJMLwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 07:52:44 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:48032 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759152AbZJMLwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 07:52:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JDSV+HKXVlRBKyVthn4LmqmIRPPlfAe98C2Vk0dM8jFbWYzFOTO4CYTO9QW9FJdVML
         +x+EddiL59UH0G4i6AMtbpauASOlfEBW9dFfhTlj9q/Cjw7meQbj5vr/Ixxdl7+XYndc
         BgJTjA3c+fw1UDZlQ1zjuY8t5pKKG4WM5mkcg=
MIME-Version: 1.0
In-Reply-To: <20091013100101.GA26846@elte.hu>
References: <4727185d0910130118m5387058dndb02ac9b384af9f0@mail.gmail.com>
	 <20091013100101.GA26846@elte.hu>
Date: Tue, 13 Oct 2009 13:51:35 +0200
Message-ID: <4727185d0910130451h3a5adcebtc0c06f48b6c9ab99@mail.gmail.com>
Subject: Re: [PATCH] [PERF] do not manually count string lengths
From: Vincent Legoll <vincent.legoll@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, paulus@samba.org,
       a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 12:01 PM, Ingo Molnar <mingo@elte.hu> wrote:
> We should add 'F:' file patterns to that entry i guess ...
>
> Something like:
>
> F:      kernel/perf_event.c
> F:      include/linux/perf_event.h
> F:      arch/*/*/kernel/perf_event.c
> F:      arch/*/include/asm/perf_event.h
> F:      tools/perf/
>
> Would do the trick. Mind sending a patch for that too?

Yep, I'll do, but a quick find in the tree may reveal other
suspects that could be in the same league:

$ find . -name .git -prune -false -o -name drivers -prune \
-false -o -name '*perf*' | grep -v perfmon | grep -v gperf

arch/*/kernel/perf_event.c

arch/frv/lib/perf_event.c
arch/x86/kernel/cpu/perf_event.c

or maybe not:

arch/powerpc/kernel/perf_callchain.c
arch/parisc/kernel/perf_asm.S
arch/parisc/kernel/perf_images.h
arch/parisc/kernel/perf.c
arch/parisc/include/asm/perf.h

Was your list really comprehensive ?

-- 
Vincent Legoll
