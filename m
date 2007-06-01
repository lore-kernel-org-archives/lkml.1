Return-Path: <linux-kernel-owner+w=401wt.eu-S1763527AbXFATuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763527AbXFATuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762504AbXFATuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:50:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47683 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762410AbXFATt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:49:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: [PATCH] x86: Document the hotplug code is incompatible with x86 irq handling
References: <fa.tUMR7tAB+jMgtfyl/LJ7U9QMgBs@ifi.uio.no>
	<465EDCF4.7010700@shaw.ca> <m1abvl3shh.fsf@ebiederm.dsl.xmission.com>
	<200705312212.34053.rjw@sisk.pl>
Date: Fri, 01 Jun 2007 13:48:29 -0600
In-Reply-To: <200705312212.34053.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Thu, 31 May 2007 22:12:33 +0200")
Message-ID: <m1d50fzcaa.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> Cool.
>> 
>> My patch does not change the functionality of the code just complains
>> very loudly that it is broken.
>> 
>> Further the code is broken at a design level.  The code isn't
>> problematic the code is impossible.  The cpu hotplug code can not be
>> fixed on x86 without a redesign of the generic cpu hotplug code.
>> 
>> Suspend does not need to use cpu hotplug because it already gets in
>> deep with the drivers, and can stop interrupts at the source.  I know
>> there was some talk about this doing this earlier, but I don't know if
>> anything came of that discussion.
>> 
>> Regardless if you care about this being a problem feel free to fix the
>> relevant code so it attempts to do something that the hardware
>> actually supports.
>> 
>> But if the suspend needs this code for smp support it is also broken.
>
> Well, from the functionality point of view, it's not.  We have no problems
> with it, at least not that I know of.

Luck, or enough other issues someone hasn't tracked their problems
down to this.  On the pure cpu hotplug path I just got a bug
report about it not working:  http://lkml.org/lkml/2007/5/31/419

So apparently real people can hit this one.  Not just theoretical
people seen by code reviewers.

The code is broken by design and cannot be made to support existing
x86 SMP systems.  Please find a way to use something that works.

The suspend path is already talking to the drivers and can stop IRQs
at their source so it should not be a big deal.

Eric
