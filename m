Return-Path: <linux-kernel-owner+w=401wt.eu-S1751512AbZHLMGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbZHLMGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 08:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZHLMGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 08:06:10 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:10033 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZHLMGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 08:06:09 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 0/3] cpu: idle state framework for offline CPUs.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Li, Shaohua" <shaohua.li@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Joel Schopp <jschopp@austin.ibm.com>,
       "Brown, Len" <len.brown@intel.com>, Balbir Singh <balbir@in.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090812115806.GK24339@elf.ucw.cz>
References: <20090805142311.553.78286.stgit@sofia.in.ibm.com>
	 <20090806015855.GA20596@sli10-desk.sh.intel.com>
	 <20090809120818.GA1338@ucw.cz> <200908091522.02898.rjw@sisk.pl>
	 <20090810081941.GA18649@elf.ucw.cz>
	 <1249950137.11545.38184.camel@localhost.localdomain>
	 <20090812115806.GK24339@elf.ucw.cz>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 14:05:43 +0200
Message-Id: <1250078743.10001.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-12 at 13:58 +0200, Pavel Machek wrote:
> Hi!
> 
> > May be having (to pick a number) 3 possible offline states for all
> > platforms with one for halt equivalent and one for deepest possible that
> > CPU can handle and one for deepest possible that platform likes for
> > C-states may make sense. Will keeps things simpler in terms of usage
> > expectations and possibly reduce the misuse oppurtubity?
> 
> Maybe just going to the deepest offline state automatically is the
> easiest option?
> 
> cpu hotplug/unplug should be rare-enough operation that the latencies
> do not really matter, right?

Ha, it uses kstopmachine, anybody caring about hotplug latencies is
insane.

And yeah, I'm not quite sure what this user-interface is good for
either. Having an in-kernel management layer where you can register
various idle routines makes sense. But exposing it to userspace,.. not
so much.

The idle thread can select an idle routine under constraints of the QoS
latency constraints, the unplug loop however should indeed select the
one that is available to dead cpus (not all idle routines are available
from what people tell me), and yields the best power savings.



