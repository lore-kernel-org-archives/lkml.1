Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbXGTLuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbXGTLuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbXGTLun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:50:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbXGTLun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:50:43 -0400
Message-ID: <46A0A186.4030908@redhat.com>
Date: Fri, 20 Jul 2007 07:50:30 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: "clameter@sgi.com" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
References: <20070531002047.702473071@sgi.com>	 <20070531003012.302019683@sgi.com>	 <a781481a0707200341o21381742rdb15e6a9dc770d27@mail.gmail.com>	 <46A097FE.3000701@redhat.com>	 <a781481a0707200427y7a29257fpfa5978c391eb3534@mail.gmail.com>	 <46A09DB2.5040408@redhat.com> <a781481a0707200440v48dcf70fv621aec863562880c@mail.gmail.com>
In-Reply-To: <a781481a0707200440v48dcf70fv621aec863562880c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 7/20/07, Chris Snook <csnook@redhat.com> wrote:
>> Satyam Sharma wrote:
>> > On 7/20/07, Chris Snook <csnook@redhat.com> wrote:
>> >> Satyam Sharma wrote:
>> >> > [ Just cleaning up my inbox, and stumbled across this thread ... ]
>> >> >
>> >> >
>> >> > On 5/31/07, clameter@sgi.com <clameter@sgi.com> wrote:
>> >> >> Introduce CONFIG_STABLE to control checks only useful for 
>> development.
>> >> >>
>> >> >> Signed-off-by: Christoph Lameter <clameter@sgi.com>
>> >> >> [...]
>> >> >>  menu "General setup"
>> >> >>
>> >> >> +config STABLE
>> >> >> +       bool "Stable kernel"
>> >> >> +       help
>> >> >> +         If the kernel is configured to be a stable kernel then
>> >> various
>> >> >> +         checks that are only of interest to kernel development
>> >> will be
>> >> >> +         omitted.
>> >> >> +
>> >> >
>> >> >
>> >> > "A programmer who uses assertions during testing and turns them off
>> >> > during production is like a sailor who wears a life vest while 
>> drilling
>> >> > on shore and takes it off at sea."
>> >> >                                                - Tony Hoare
>> >> >
>> >> >
>> >> > Probably you meant to turn off debug _output_ (and not _checks_)
>> >> > with this config option? But we already have CONFIG_FOO_DEBUG_BAR
>> >> > for those situations ...
>> >>
>> >> There are plenty of validation and debugging features in the kernel
>> >> that go WAY
>> >> beyond mere assertions, often imposing significant overhead
>> >> (particularly when
>> >> you scale up) or creating interfaces you'd never use unless you were
>> >> doing
>> >> kernel development work.  You really do want these features completely
>> >> removed
>> >> from production kernels.
>> >
>> > As for entire such "development/debugging-related features", most (all,
>> > really)
>> > should anyway have their own config options.
>>
>> They do.  With kconfig dependencies, we can ensure that those config 
>> options are
>> off when CONFIG_STABLE is set.  That way you only have to set one 
>> option to
>> ensure that all these expensive checks are disabled.
> 
> Oh, so you mean use this (the negation of this, actually) as a universal
> kconfig dependency of all other such development/debugging related stuff?
> Hmm, the name is quite misleading in that case.

There are many different ways you can use it.  If I'm writing a configurable 
feature, I could make it depend on !CONFIG_STABLE, or I could ifdef my code out 
if CONFIG_STABLE is set, unless a more granular option is also set.  The 
maintainer of the code that uses the config option has a lot of flexibility, at 
least until we start enforcing standards.

	-- Chris
