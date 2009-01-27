Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbZA0Pdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbZA0Pdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZA0Pdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:33:40 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51671 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752466AbZA0Pdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:33:40 -0500
Subject: Re: [PATCH 1/2 #tj-percpu] x86: fix build breakage on voyage
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <497EF43D.9010303@gmail.com>
References: <20090126103243.GA31307@elte.hu>
	 <1232977445-11815-1-git-send-email-brgerst@gmail.com>
	 <20090126141832.GA31442@elte.hu> <497E6B34.1020508@kernel.org>
	 <497E8778.9060503@gmail.com>
	 <1233032609.3248.78.camel@localhost.localdomain>
	 <497E9B9D.4010102@gmail.com> <20090127113734.GA28249@elte.hu>
	 <497EF43D.9010303@gmail.com>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 09:33:37 -0600
Message-Id: <1233070417.3231.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 20:47 +0900, Tejun Heo wrote:
> Hello, Ingo.
> 
> Ingo Molnar wrote:
> >> +#ifdef CONFIG_X86_LOCAL_APIC
> >>  	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
> >>  	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
> >> +#endif
> > 
> > That patch is not acceptable - it is ugly and it adds another set of
> > #ifdefs to an already complex piece of code.
> 
> Well, although the patch itself does add #ifdef, if you look over the
> whole series, voyager is now a much more conforming citizen in the x86
> world.  There are several solutions to this particular one.
> 
> 1. Just let apic stuff defined and not use it in voyager if the ifdef
>    is disturbing.  IIUC, apic isn't used in voyager at all, right?
> 
> 2. Clean up early percpu stuff so that it each early percpu variable
>    doesn't need to be explicitly copied and cleared, which is the
>    actual problem here.

Right ... there's a variant of this where the copying and clearing is
done within the actual file that defines the variable (i.e. a hook
approach).

> 3. But, then again, the current interim and ugly way of doing it isn't
>    too bad considering the small number of early per cpu users.
> 
> To me the current form doesn't look too bad but if it's too ugly,
> maybe doing #2 is not such a bad idea such that early percpu can be
> transferred to percpu in more systematic way.  It still feels a bit
> like overdoing it tho.
> 
> What do you think?

What's the actual goal of setup_percpu.c?  To have a single location for
all the per_cpu initialisation?  If so then it's hard to get away from
all the ifdefs.  If there are alternative ways of arranging the file
then I think splitting some of the conditional pieces into other files
would work.

James


