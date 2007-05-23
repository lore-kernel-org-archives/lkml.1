Return-Path: <linux-kernel-owner+w=401wt.eu-S935330AbXEWQch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935330AbXEWQch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759725AbXEWQca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:32:30 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:43531 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbXEWQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:32:29 -0400
Subject: Re: [PATCH -rt] ARM TLB flush fix: don't forget to re-enable
	preemption
From: Daniel Walker <dwalker@mvista.com>
To: Kevin Hilman <khilman@mvista.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1179936837.7051.11.camel@vence.hilman.org>
References: <20070522230128.891568116@mvista.com>
	 <1179876320.15427.214.camel@imap.mvista.com>
	 <1179877296.6122.74.camel@vence.hilman.org>
	 <20070523092232.GA9482@flint.arm.linux.org.uk>
	 <1179936837.7051.11.camel@vence.hilman.org>
Content-Type: text/plain
Date: Wed, 23 May 2007 09:30:03 -0700
Message-Id: <1179937803.15427.250.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 09:13 -0700, Kevin Hilman wrote:

> Note that my patch simply adds an enable to match the disable added by
> the -rt patch.  I'm not sure where the disable originally came from, but
> there are disable/enable pairs scattered throughout tlbflush.h in the
> -rt patch.
> 
> If this one isn't necessary, then the others probably are not either.
> In most cases there are 2 mcr instructions inside the critical section.
> One for the dsb() and the other for the actual function.
> 
> Russell, is there a reason any of these sections should be atomic?

Under normal preempt modes those functions would end running with
preemption disabled , but with PREEMPT_RT enabled they become
preemptive .. I may have been mistaken , but my impression was that one
mcr instruction was executed and it was atomic , so there was no need
for additional protection there..

If there are two mcr instructions then you could be preempted between
the two, which may be unsafe depending on what those instructions are
doing ..

Daniel

