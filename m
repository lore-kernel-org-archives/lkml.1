Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZFVO46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZFVO46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbZFVO4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:56:49 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:24476 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbZFVO4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:56:47 -0400
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
Cc: Brice Goglin <Brice.Goglin@inria.fr>, "'Andi Kleen'" <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org,
       Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
In-Reply-To: <4A3F95F1.4020507@lfbs.rwth-aachen.de>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
	 <87zldjn597.fsf@basil.nowhere.org>
	 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
	 <20090612103251.GJ25568@one.firstfloor.org>
	 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
	 <1245119977.6724.40.camel@lts-notebook>
	 <003001c9ee8a$97e5b100$c7b11300$@rwth-aachen.de>
	 <1245164395.15138.40.camel@lts-notebook>
	 <000501c9ef1f$930fa330$b92ee990$@rwth-aachen.de>
	 <1245299856.6431.30.camel@lts-notebook> <4A3F7A49.6070805@inria.fr>
	 <4A3F95F1.4020507@lfbs.rwth-aachen.de>
Content-Type: text/plain
Organization: HP/LKTT
Date: Mon, 22 Jun 2009 10:56:46 -0400
Message-Id: <1245682606.7799.64.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 16:32 +0200, Stefan Lankes wrote:
> 
> Brice Goglin wrote:
> > Lee Schermerhorn wrote:
> >> On Wed, 2009-06-17 at 09:45 +0200, Stefan Lankes wrote:
> >>   
> >>
> >> Today I rebased the migrate on fault patches to 2.6.30-mmotm-090612...
> >> [along with my shared policy series atop which they sit in my tree].
> >> Patches reside in:
> >>
> >> http://free.linux.hp.com/~lts/Patches/PageMigration/2.6.30-mmotm-090612-1220/
> >>
> >>   
> > 
> > I gave this patchset a try and indeed it seems to work fine, thanks a
> > lot. But the migration performance isn't very good. I am seeing about
> > 540MB/s when doing mbind+touch_all_pages on large buffers on a
> > quad-barcelona machines. move_pages gets 640MB/s there. And my own
> > next-touch implementation were near 800MB/s in the past.
> 
> I used a modified stream benchmark to evaluate the performance of Lee's 
> and my version of the next-touch implementation. In this low-level 
> benchmark is Lee's patch better than my patch. I think that Brice and I 
> use the same technique to realize affinity-on-next-touch. Do you use 
> another kernel version to evaluate the performance?

Hi, Stefan:

I also used a [modified!] stream benchmark to test my patches.  One of
the modifications was to dump the time it takes for one pass over the
data arrays to a specific file description, if that file description was
open at start time--e.g., via something like "4>stream_times".  Then, I
increased the number of iterations to something large so that I could
run other tests during the stream run.  I plotted the "time per
iteration" vs iteration number and could see that after any transient
load, the stream benchmark returned to a good [not sure if maximal]
locality state.  The time per interation was comparable to hand
affinitized of the threads.  Without automigration and hand
affinitization, any transient load would scramble the location of the
threads relative to the data region they were operating on due to load
balancing.  The more nodes you have, the less likely you'll end up in a
good state.

I was using a parallel kernel make [-j <2*nr_cpus>] as the load.  In
addition to the stream returning to good locality, I noticed that the
kernel build completed much faster in the presence of the stream load
with automigration enabled.  I reported these results in a presentation
at LCA'07.  Slides and video [yuck! :)] are available on line at the
LCA'07 site.

Regards,
Lee

