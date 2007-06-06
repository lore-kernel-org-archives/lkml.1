Return-Path: <linux-kernel-owner+w=401wt.eu-S1762512AbXFFKTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762512AbXFFKTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759385AbXFFKTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:19:30 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:42238 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759410AbXFFKT3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:19:29 -0400
Message-Id: <4666A677.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 06 Jun 2007 12:20:07 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <virtualization@lists.osdl.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Chris Wright" <chrisw@sous-sol.org>, "Andi Kleen" <ak@suse.de>,
       "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [patch 14/33] xen: xen time implementation
References: <20070522140941.802382212@goop.org>
 <20070522141252.030961467@goop.org> <46668EC6.76E4.0078.0@novell.com>
 <466686E2.4040004@goop.org>
In-Reply-To: <466686E2.4040004@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>  But I think that a clock source can be expected to be
>> monotonic anyway, which Xen's interpolation mechanism doesn't
>> guarantee across multiple CPUs. (I'm actually beginning to think that
>> this might also be the reason for certain test suites occasionally reporting
>> timeouts to fire early.)
>>   
>
>Does the kernel expect the tsc clocksource to be completely monotonic
>across cpus?  Any form of cpu-local clocksource is going to have this
>problem; I wonder if clocksources can really only be useful if they're
>always referring to a single system-wide time reference - seems like a
>bit of a limitation.

I suppose so - the clock source's rating gets set to zero if it can be predicted
that the TSCs aren't all synchronized, which should pretty much exclude the
use of this clock source for any other than fallback if there's really nothing
else available.

Jan

