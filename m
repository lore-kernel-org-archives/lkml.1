Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYGWQnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYGWQnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 12:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYGWQnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 12:43:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbYGWQnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 12:43:24 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Rik van Riel <riel@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: systemtap & backward compatibility, was Re: [RFC] systemtap:  begin the process of using proper kernel APIs
References: <487E8CE4.70105@redhat.com>
	<1216259391.3358.85.camel@localhost.localdomain>
	<1216304290.5515.11.camel@localhost.localdomain>
	<1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain>
	<y0m7ibkjrcj.fsf@ton.toronto.redhat.com>
	<1216325546.5515.63.camel@localhost.localdomain>
	<20080717202634.GI18295@redhat.com>
	<1216328769.5515.78.camel@localhost.localdomain>
	<20080717213355.GJ18295@redhat.com>
	<20080722140015.37628ea4@bree.surriel.com>
	<20080723150434.GC11191@redhat.com>
	<20080723082856.334f9c17__2909.60763018138$1216827051$gmane$org@infradead.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 23 Jul 2008 12:41:37 -0400
In-Reply-To: <20080723082856.334f9c17__2909.60763018138$1216827051$gmane$org@infradead.org> (Arjan van de Ven's message of "Wed, 23 Jul 2008 08:28:56 -0700")
Message-ID: <y0m3am0blj2.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> [...]
>> It does happen to *generate* kernel modules.  The way that such a
>> module must interface with any particular kernel is naturally subject
>> to the whims & desires of the kernel du jour.  This is why we have a
>> mass of mechanism to try to automatically speak to each kernel version
>> as appropriate.

> and this is where I strongly disagree.  THIS part *has* to be in the
> kernel source, so that we can change it WITH the kernel as we change
> it. [...]  But to have any chance at all of systemtap being
> sustainable, this part of the stack has to be together with where
> the changes happen.

OK.  It will take us some time to figure out to what extent this would
be feasible.  Maybe a topic for Portland.


>> It is desirable to minimize this mass for obvious reasons.  When a new
>> upstream kernel comes out with a tasty new feature -- or a less tasty
>> API rewrite -- we need to extend systemtap to support that too.
>
> At that point you are already 3 months too late for me, and probably
> for most of my fellow kernel hackers. 

(Really?  Have we ever been 3 months behind supporting the git kernel?)


> (and when it's seen it gets a rather luke warm reception, but that's
> a different story).

I hope the backward compatibility issue, as it stands today, helps
explain the reasons for the current deal with kprobes.


In the interim (before we come up with a way of moving more
kernel-coupled systemtap code into kernel.org/git), would y'all
consider an arrangement?  Those of you who care about systemtap, and
are intending to make an incompatible kernel/module interface change,
please run the systemtap testsuite before & after.  If it regresses,
send us a note or a patch.  If practical, we'll integrate it (and add
any backward-compatibility hacks if needed) into systemtap.


- FChE
