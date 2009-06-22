Return-Path: <linux-kernel-owner+w=401wt.eu-S1757689AbZFVUQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689AbZFVUQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZFVUQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:16:10 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:42303 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750913AbZFVUQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:16:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
X-IronPort-AV: E=Sophos;i="4.42,271,1243807200";   d="scan'208";a="16346134"
Message-id: <4A3FE689.8090603@lfbs.rwth-aachen.de>
Date: Mon, 22 Jun 2009 22:16:09 +0200
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
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
 <1245680649.7799.54.camel@lts-notebook> <4A3FA326.8030802@inria.fr>
 <1245689724.7799.124.camel@lts-notebook> <4A3FBA11.8030304@inria.fr>
 <4A3FC68A.2030104@lfbs.rwth-aachen.de> <4A3FD721.3050606@inria.fr>
In-reply-to: <4A3FD721.3050606@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Brice Goglin wrote:
> Stefan Lankes wrote:
>> I am not able to reconstruct any performance drawbacks on my system.
>> Could you send me your low-level benchmark?
> 
> It's attached. As you may see, it's fairly trivial. It just does several
> iterations of mbind+touch_all_pages for different power-of-two buffer
> sizes. Just replace mbind with madvise in the inner loop if you want to
> try with your affinit-on-next-touch.

I use MPOL_NOOP instead of MPOL_PREFERRED. On my system, MPOL_NOOP is 
defined in as 4 (-> include/linux/mempolicy.h).

By the way, do you also add Lee's "shared policy" patches? These patches 
add MPOL_MF_SHARED, which is specified as 3. Afterwards, you have to 
define MPOL_MF_LAZY as 4.

I got following performance results with MPOL_NOOP:

# Nb_pages      Cost(ns)
2       44539
4       44695
8       53937
16      61625
32      87757
64      135070
128     233812
256     428539
512     870476
1024    1695859
2048    3280695
4096    6450328
8192    12719187
16384   25377750
32768   50431375
65536   101970000
131072  216200500
262144  511706000

I got following performance results with MPOL_PREFERRED:

# Nb_pages      Cost(ns)
2       50742
4       58656
8       79929
16      117171
32      195304
64      354851
128     744835
256     1354476
512     2759570
1024    5433304
2048    10173390
4096    20178453
8192    36452343
16384   71077375
32768   141738000
65536   281460250
131072  576971000
262144  1231694000

> Which kernels are you using when comparing your next-touch
> implementation with Lee's patchset?
> 

The current mmotm tree.

Regards,

Stefan
