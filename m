Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZHYKZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZHYKZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 06:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZHYKZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 06:25:07 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:46814
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751740AbZHYKZG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 06:25:06 -0400
X-SpamScore: 1
X-BigFish: VPS1(z34a4jz1432R98dN936eM10d1Ia594izz1202hzz3198u327alz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KOXGXM-01-6G0-02
X-M-MSG: 
Date: Tue, 25 Aug 2009 12:24:09 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
	cpumask on multi-node processors
Message-ID: <20090825102409.GK20811@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134604.GD29327@alberich.amd.com> <1251128176.7538.301.camel@twins> <20090825093101.GJ20811@alberich.amd.com> <1251194143.7538.1128.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1251194143.7538.1128.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Aug 2009 10:24:09.0779 (UTC) FILETIME=[2EF30830:01CA256E]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 11:55:43AM +0200, Peter Zijlstra wrote:
> On Tue, 2009-08-25 at 11:31 +0200, Andreas Herrmann wrote:
> > On Mon, Aug 24, 2009 at 05:36:16PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2009-08-20 at 15:46 +0200, Andreas Herrmann wrote:
> > > > The correct mask that describes core-siblings of an processor
> > > > is topology_core_cpumask. See topology adapation patches, especially
> > > > http://marc.info/?l=linux-kernel&m=124964999608179
> > > 
> > > 
> > > argh, violence, murder kill.. this is the worst possible hack and you're
> > > extending it :/
> > 
> > So this is the third code area
> > (besides sched_*_power_savings sysfs interface, and the __cpu_power fiddling)
> > that is crap, mess, a hack.
> > 
> > Didn't know that I'd enter such a minefield when touching this code. ;-(
> 
> Yeah, you're lucky that way ;-) Its been creaking for a while, and I've
> been making noises to the IBM people (who so far have been the main
> source of power saving patches) to clean this up, but now you trod onto
> all of it at once..
> 
> > What would be your perferred solution for the
> > core_cpumask/llc_shared_map stuff?  Another domain level to get rid of
> > this function?
> 
> Right, I'd like to see everything exposed as domain levels.
> 
> 
> numa-cluster
> numa
> socket
> in-socket-numa
> multi-core
> shared-cache
> core
> threads
> 
> We currently have a fixed order of these things, but I think we should
> simply provide helpers for building the sd tree and let the arch code do
> that instead of exporting all these masks in a fixed order.
> 
> Once we get the arch domain tree, we do degenerate stuff to cull all the
> trivial domains and fold SD flags.

So any in-socket-numa is only going to haeppen with the arch-defined
domain tree.

Now that this is settled you should throw away the
__build_sched_domains cleanup patches that are in tip. They won't be
of use when domain creation code is basically changed.


Regards,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


