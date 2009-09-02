Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbZIBFmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbZIBFmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 01:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZIBFmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 01:42:40 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:37809 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729AbZIBFmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 01:42:39 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [v4 PATCH 1/5]: cpuidle: Cleanup drivers/cpuidle/cpuidle.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20090901113840.GH7599@linux.vnet.ibm.com>
References: <20090901113704.GG7599@linux.vnet.ibm.com>
	 <20090901113840.GH7599@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 07:42:24 +0200
Message-Id: <1251870144.7547.48.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 17:08 +0530, Arun R Bharadwaj wrote:
> * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-01 17:07:04]:
> 
> Cleanup drivers/cpuidle/cpuidle.c
> 
> Cpuidle maintains a pm_idle_old void pointer because, currently in x86
> there is no clean way of registering and unregistering a idle function.

Right, and instead of fixing that, they build this cpuidle crap on top,
instead of replacing the current crap with it.

> So remove pm_idle_old and leave the responsibility of maintaining the
> list of registered idle loops to the architecture specific code. If the
> architecture registers cpuidle_idle_call as its idle loop, only then
> this loop is called.

OK, that's a start I guess. Best would be to replace all of pm_idle with
cpuidle, which is what should have been done from the very start.

If cpuidle cannot fully replace the pm_idle functionality, then it needs
to fix that. But having two layers of idle functions is just silly.

Looking at patch 2 and 3, you're making the same mistake on power, after
those patches there are multiple ways of registering idle functions, one
through some native interface and one through cpuidle, this strikes me
as undesirable.

If cpuidle is a good idle function manager, then it should be good
enough to be the sole one, if its not, then why bother with it at all.


