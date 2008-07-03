Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbYGCLzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbYGCLzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 07:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYGCLzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 07:55:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:36305 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbYGCLzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:55:11 -0400
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
In-Reply-To: <m1zlozmg2k.fsf@frodo.ebiederm.org>
References: <1214916335.20711.141.camel@pasglop>
	 <486B0298.5030508@linux.intel.com> <1214977447.21182.33.camel@pasglop>
	 <1215007896.3330.6.camel@localhost.localdomain>
	 <1215032409.21182.56.camel@pasglop>  <m1zlozmg2k.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 20:31:26 +1000
Message-Id: <1215081086.19689.6.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 03:12 -0700, Eric W. Biederman wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> > The question is: is that significantly less overhead than just spawning
> > a new full blown kernel thread ? enough to justify the complexity ? at
> > the end of the day, it means allocating a stack (which on ppc64 is still
> > 16K, I know it sucks)... 
> 
> I looked at this a while ago.  And right  now kernel_thread is fairly light.
> kthread_create has latency issues because we need to queue up a task on
> our kernel thread spawning daemon, and let it fork the child.  Needing
> to go via the kthread spawning daemon didn't look fundamental, just something
> that was a challenge to sort out.

Yes. I was thinking that if it becomes an issue, we could special case
something in the scheduler to pop them.

Ben.


