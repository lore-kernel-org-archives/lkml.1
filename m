Return-Path: <linux-kernel-owner+w=401wt.eu-S1751435AbXBMXEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbXBMXEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbXBMXEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:04:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbXBMXEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:04:11 -0500
Message-ID: <45D23E3D.7020000@redhat.com>
Date: Tue, 13 Feb 2007 17:39:57 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061004)
MIME-Version: 1.0
To: Andi Kleen <ak@muc.de>
CC: Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/11] VMI / Paravirt bugfixes for 2.6.21
References: <200702060352.l163q87K000713@zach-dev.vmware.com> <1170736029.29293.31.camel@localhost.localdomain> <45C809F9.2090905@vmware.com> <1170738676.29293.35.camel@localhost.localdomain> <1170752856.7324.5.camel@laptopd505.fenrus.org> <20070206122514.GA47229@muc.de>
In-Reply-To: <20070206122514.GA47229@muc.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> hmm stolen time could even be useful without virtualization; to a large
>> degree, if cpufreq reduces the speed of your cpu you have "stolen
>> cycles" that way... I wonder if this concept can be used for that as
>> well...

> I don't see the point, frankly.

In a virtualized environment, steal time shows the amount of
contention between guests.

If you have two guests trying to use 100% of the CPU, but they
have to share the CPU and each gets 50%, then the steal time
will be 50% on each guest.

This allows the sysadmin to see that the guests would have
been able to run faster, if only they were not fighting over
the same CPU.  Performance could have been improved by doing
live migration.

Contrast this to a client/server (or backend/middle tier)
application on one system, where both virtual machines work
together.  They can still end up getting 50% of the CPU each,
but a lot of the time they do not want the CPU simultaneously.

In that case, there will be idle time and the amount of steal
time will be way lower.

Steal time allows you to distinguish between "the CPU is not
fast enough" and "I have too many virtual machines on the CPU"
and "things are running OK".

As for steal time in a non-virtualized environment, I am not
quite sure either.  I can't think of any action the sysadmin
(or some load balancing program) could take, based on the
information...

-- 
All Rights Reversed
