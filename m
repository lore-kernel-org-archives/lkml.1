Return-Path: <linux-kernel-owner+w=401wt.eu-S2992442AbXCGVqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992442AbXCGVqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992632AbXCGVqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:46:30 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:36594 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992442AbXCGVq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:46:29 -0500
Message-ID: <45EF31AE.1070800@vmware.com>
Date: Wed, 07 Mar 2007 13:42:06 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>	 <1173178774.24738.311.camel@localhost.localdomain>	 <45EDD82F.90204@vmware.com>	 <1173225182.24738.507.camel@localhost.localdomain>	 <45EE0628.1080108@goop.org>  <45EE08E8.2020008@vmware.com>	 <1173228544.24738.514.camel@localhost.localdomain>	 <45EE0D10.7070807@vmware.com>	 <1173230305.24738.529.camel@localhost.localdomain>	 <45EE1EA3.90803@vmware.com>	 <1173256666.24738.576.camel@localhost.localdomain>	 <45EEF966.6060902@goop.org> <1173300032.24738.750.camel@localhost.localdomain>
In-Reply-To: <1173300032.24738.750.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 21:46:28.0799 (UTC) FILETIME=[0FE73CF0:01C76102]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2007 12:40 PM, Thomas Gleixner wrote:
> Real hardware copes well with relative deltas for the events, even when
> it is match register based. I thought long about the support for
> absolute expiry values in cycles and decided against them to avoid that
> math hackery, which you folks now demand.

First of all, I'm not "demanding" anything. I'm just trying to have a 
technical discussion about the issues.  If it comes out that absolute 
expiry can't be done cleanly, and the cost out weighs the benefit, then 
so be it.  But, what's so wrong about having the discussion?

When you do have match register (or count and compare, whatever you want 
to call it) based timers in real hardware, the relative expiry interface 
in software is a bit suboptimal.  You still have no idea how much time 
has already gone by between the time you calculated the delta and when 
you setup the hardware (you have a pretty good estimate, but can't know 
for sure unless you disable caches and all other sources of 
non-determinate latencies).  So, you will always be a little late in 
your timer firing.  You may argue that no client of clockevents cares 
about this little bit of lateness.  But, it does exist, and can be 
solved with a software interface that talks in terms of absolute expiries.

Perhaps we can't get around the 128-bit math problem, or maybe we can 
think of a clever solution.  If we can't, then maybe fixing the lateness 
is not worth the cost 128-bit math.  But, maybe there is a clean way 
around the 128-bit math and we just need to approach it from another angle.

Dan
