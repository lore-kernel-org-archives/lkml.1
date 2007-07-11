Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbXGKEqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbXGKEqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 00:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXGKEpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 00:45:52 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56325 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXGKEpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 00:45:51 -0400
Date: Wed, 11 Jul 2007 10:25:16 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul Menage" <menage@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-ID: <20070711045516.GH2927@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710105240.GA20914@linux.vnet.ibm.com> <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com> <20070710115319.0bdaff34.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710115319.0bdaff34.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 11:53:19AM -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2007 11:34:38 -0700
> "Paul Menage" <menage@google.com> wrote:
> 
> > Andrew, how about we merge enough of the container framework to
> > support CFS? Bits we could leave out for now include container_clone()
> > support and the nsproxy subsystem, fork/exit callback hooks, and
> > possibly leave cpusets alone for now (which would also mean we could
> > skip the automatic release-agent stuff). I'm in Tokyo for the Linux
> > Foundation Japan symposium right now, but I should be able to get the
> > new patchset to you for Friday afternoon.
> 
> mm..  Given that you propose leaving bits out for the 2.6.23 merge, and
> that changes are still pending and that nothing will _use_ the framework in
> 2.6.23 [...]

Andrew,
	The cpu group scheduler is ready and waiting for the container patches 
in 2.6.23 :)

Here are some options with us:

	a. (As Paul says) merge enough of container patches to enable
	   its use with cfs group scheduler (and possibly cpusets?)

	b. Enable group scheduling bits in 2.6.23 using the user-id grouping 
	   mechanism (aka fair user scheduler). For 2.6.24, we could remove 
	   this interface and use Paul's container patches instead. Since this 
	   means change of API interface between 2.6.23 and 2.6.24, I don't 
	   prefer this option.

	c. Enable group scheduling bits only in -mm for now (2.6.23-mmX), using 
	   Paul's container patches. I can send you a short patch that hooks up 
	   cfs group scheduler with Paul's container infrastructure.

If a. is not possible, I would prefer c.

Let me know your thoughts ..

-- 
Regards,
vatsa
