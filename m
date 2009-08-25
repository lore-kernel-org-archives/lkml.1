Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbZHYI4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbZHYI4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZHYI4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:56:03 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:25895
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751050AbZHYI4C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:56:02 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz1432R14c3L98dN936eM1442Ja594izz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KOXCT5-01-3IN-02
X-M-MSG: 
Date: Tue, 25 Aug 2009 10:55:31 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] sched: Allow NODE domain to be parent of MC
	instead of CPU domain
Message-ID: <20090825085531.GG20811@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134245.GA29327@alberich.amd.com> <1251127960.7538.298.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1251127960.7538.298.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Aug 2009 08:55:31.0534 (UTC) FILETIME=[CD073EE0:01CA2561]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 05:32:40PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-08-20 at 15:42 +0200, Andreas Herrmann wrote:
> > The level of NODE domain's child domain is provided in s_data.numa_child_level.
> > Then several adaptions are required when creating the domain hierarchy.
> > In case NODE domain is parent of MC domain we have to:
> > - limit NODE domains' span in sched_domain_node_span() to not exceed
> >   corresponding topology_core_cpumask.
> > - fix CPU domain span to cover entire cpu_map
> > - fix CPU domain sched groups to cover entire physical groups instead of
> >   covering a node (a node sched_group might be a proper subset of a CPU
> >   sched_group).
> > - use correct child domain in init_numa_sched_groups_power() when
> >   calculating sched_group.__cpu_power in NODE domain
> > - calculate group_power of NODE domain after its child domain
> > 
> > Note: As I have no idea when the ALLNODES domain is required
> >       I assumed that an ALLNODES domain exists only if NODE domain
> >       is parent of CPU domain.
> 
> I think its only used when the regular node level is too large, then we
> split it into smaller bits. SGI folks who run crazy large machines use
> this.

Ok.

> /me mumbels about renaming the domain level, CPU is the physical socket
> level, right? stupid names.
> 
> Patch sounds funky though, numa_child_level should be effident from the
> tree build.

In the current code the numa_child_level must be known before/while
the tree is built. Of course once the tree is ready, the child domain
is known (apart from degeneration).

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


