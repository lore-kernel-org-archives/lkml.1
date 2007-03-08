Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbXCHUTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbXCHUTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbXCHUTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:19:05 -0500
Received: from gw.goop.org ([64.81.55.164]:56960 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbXCHUTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:19:04 -0500
Message-ID: <45F06FB3.105@goop.org>
Date: Thu, 08 Mar 2007 12:18:59 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Daniel Arai <arai@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       akpm@linux-foundation.org, john stultz <johnstul@us.ibm.com>,
       tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <1173313373.24738.937.camel@localhost.localdomain> <45EF6077.9090302@vmware.com> <20070308182456.GH19575@sequoia.sous-sol.org> <45F06720.8080901@goop.org> <20070308194740.GJ10574@sequoia.sous-sol.org> <45F06989.8030207@goop.org> <20070308201033.GK10574@sequoia.sous-sol.org>
In-Reply-To: <20070308201033.GK10574@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>   
>> Chris Wright wrote:
>>     
>>> I agree with that, but I think that's esp. for things like create and launch
>>> new vcpu.  The IPI bit I'm not as clear on, nor running this all on native
>>> as well.
>>>   
>>>       
>> Well, native would fall back to using the existing arch/i386 versions of
>> those functions, so that's reasonably straightforward.
>>     
>
> It's the fact that we need to leave code in the kernel to run on native,
> but also do something dynamically with that same code when running
> paravirt that I'm referring to.

Why would it be any different to all the other code we've got behind
native pvops?

The ideal simplified case is that we rename
smp_send_stop/send_reschedule/prepare_cpus/etc to native_* versions.  In
the !PARAVIRT case we just call the native_* version directly; in
PARAVIRT we call via the native pv_ops structure.  Under Xen, all these
would implemented independently from the native versions.

> No, it's not the IPI itself, it's the way it's often accessed by the rest of
> the kernel (which is intertwined with genapic).  I'm happy to avoid apic
> altogether since it's effectively worthless for Xen other than
> integrating into the existing infrastructure.
>   

I guess by "rest of the kernel" you mean other stuff in arch/i386.  Yes,
that's a concern, but maybe we can tease it apart in a sensible way.

    J
