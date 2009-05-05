Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbZEEL5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbZEEL5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 07:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZEEL5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 07:57:09 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43441 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZEEL5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 07:57:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18944.10637.877638.642187@cargo.ozlabs.ibm.com>
Date: Tue, 5 May 2009 21:57:01 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: round-robining per-cpu counters
In-Reply-To: <20090505064051.GA27191@elte.hu>
References: <18943.47474.963294.862139@drongo.ozlabs.ibm.com>
	<20090505064051.GA27191@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> The reservation mechanism really suffered from not being used by 
> anything or anyone, and it thus bit-rotted across 300 follow-on 
> commits.

Yeah.

> What would be the primary usecase? Allow admin to set aside (and 
> guarantee) space for task counters? Allow admin to 'force' 
> exclusivity of counter ownership?
> 
> I think a better general solution would be to have a single 
> round-robin list for all currently active counters (both percpu and 
> task counters) - and fairly round-robin all of them. The scaling 
> information makes it obvious when this is happening.

Sounds good, but I'm having trouble visualizing how we combine a
fairly static set of per-cpu counters with several sets of per-task
counters that come and go as their tasks get scheduled in and out.
Is there some clever scheduling technique that sorts all that out?

> If admin wants stronger ownership of counters then the 
> pinned/exclusive attribute can be used.

I agree.

> We really want to keep the counter-scheduler simple, and we also 
> want to make the default to be as permissive as possible.

Definitely.

Paul.
