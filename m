Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbZH0P1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbZH0P1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbZH0P1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:27:53 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:14081 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZH0P1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:27:52 -0400
X-SpamScore: 0
X-BigFish: VPS0(z34a4jz1432R98dN936eMa594izz1202hzz3198u327alz32i6bh203h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KP1K7P-01-828-02
X-M-MSG: 
Date: Thu, 27 Aug 2009 17:25:51 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
	cpumask on multi-node processors
Message-ID: <20090827152551.GE13576@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134604.GD29327@alberich.amd.com> <1251128176.7538.301.camel@twins> <20090825093101.GJ20811@alberich.amd.com> <1251194143.7538.1128.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1251194143.7538.1128.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 27 Aug 2009 15:25:51.0319 (UTC) FILETIME=[A9225670:01CA272A]
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

Out of curiosity, when does cpu_core_mask differ from llc_shared_map
on Intel? Only in case of MCM (e.g. Core2 Quad)?

If yes, the hackery of cpu_coregroup_mask() could be replace by
the domain that I'd like to introduce for Magny-Cours:

  MC domain span would represent one die.
  The new domain would span all dies in an MCM.

Bad idea?



Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


