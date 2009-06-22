Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZFVUe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZFVUe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZFVUeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:34:22 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57417
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751124AbZFVUeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:34:21 -0400
X-IronPort-AV: E=Sophos;i="4.42,271,1243807200"; 
   d="scan'208";a="29986382"
Message-ID: <4A3FEAF0.2060301@inria.fr>
Date: Mon, 22 Jun 2009 22:34:56 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de> <87zldjn597.fsf@basil.nowhere.org> <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de> <20090612103251.GJ25568@one.firstfloor.org> <004001c9eb53$71991300$54cb3900$@rwth-aachen.de> <1245119977.6724.40.camel@lts-notebook> <003001c9ee8a$97e5b100$c7b11300$@rwth-aachen.de> <1245164395.15138.40.camel@lts-notebook> <000501c9ef1f$930fa330$b92ee990$@rwth-aachen.de> <1245299856.6431.30.camel@lts-notebook> <4A3F7A49.6070805@inria.fr> <1245680649.7799.54.camel@lts-notebook> <4A3FA326.8030802@inria.fr> <1245689724.7799.124.camel@lts-notebook> <4A3FBA11.8030304@inria.fr> <4A3FC68A.2030104@lfbs.rwth-aachen.de> <4A3FD721.3050606@inria.fr> <4A3FE689.8090603@lfbs.rwth-aachen.de>
In-Reply-To: <4A3FE689.8090603@lfbs.rwth-aachen.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Lankes wrote:
> By the way, do you also add Lee's "shared policy" patches? These
> patches add MPOL_MF_SHARED, which is specified as 3. Afterwards, you
> have to define MPOL_MF_LAZY as 4.

Yes, I applied shared-policy-* since migrate-on-fault doesn't apply
without them :)

But I have the following in include/linux/mempolicy.h after applying all
patches:
#define MPOL_MF_LAZY     (1<<3) /* Modifies '_MOVE:  lazy migrate on
fault */
#define MPOL_F_SHARED  (1 << 0) /* identify shared policies */
Where did you get your F_SHARED=3 and MF_LAZY=4?

> I got following performance results with MPOL_NOOP:
>
> # Nb_pages      Cost(ns)
> 32768   50431375
> 65536   101970000
> 131072  216200500
> 262144  511706000

Is there any migration here? Don't you just have unmap and fault without
migration? In my test program, the initialization does MPOL_BIND. So the
following MPOL_NOOP should just do nothing since the page is already
correctly placed with regard to the previous MPOL_BIND. I feel like 2us
per page looks too low for a migration and it's also very high for just
unmap and fault-in.

> I got following performance results with MPOL_PREFERRED:
>
> # Nb_pages      Cost(ns)
> 32768   141738000

That's about 60% faster than on my machine (quad-barcelona 8347HE
1.9GHz). What machine are you running on?

Brice

