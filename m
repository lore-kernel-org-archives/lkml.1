Return-Path: <linux-kernel-owner+w=401wt.eu-S1762005AbYGCNMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762005AbYGCNMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYGCNLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:11:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44741 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYGCNLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:11:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: benh@kernel.crashing.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
References: <1214916335.20711.141.camel@pasglop>
	<486B0298.5030508@linux.intel.com> <1214977447.21182.33.camel@pasglop>
	<1215007896.3330.6.camel@localhost.localdomain>
	<1215032409.21182.56.camel@pasglop>
Date: Thu, 03 Jul 2008 03:12:51 -0700
In-Reply-To: <1215032409.21182.56.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Thu, 03 Jul 2008 07:00:09 +1000")
Message-ID: <m1zlozmg2k.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;benh@kernel.crashing.org
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0507]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> The question is: is that significantly less overhead than just spawning
> a new full blown kernel thread ? enough to justify the complexity ? at
> the end of the day, it means allocating a stack (which on ppc64 is still
> 16K, I know it sucks)... 

I looked at this a while ago.  And right  now kernel_thread is fairly light.
kthread_create has latency issues because we need to queue up a task on
our kernel thread spawning daemon, and let it fork the child.  Needing
to go via the kthread spawning daemon didn't look fundamental, just something
that was a challenge to sort out.

Eric
