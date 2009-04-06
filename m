Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZDFHFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZDFHFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 03:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZDFHFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 03:05:00 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:23999 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752272AbZDFHFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 03:05:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=UkglWl5TP/9rFFFQiXt+9v6Q8drU55TWxNL59ANX8az+d9869MxIti1hQgd/mJTuV7GWnZJA5Jv8R6ULZ+TbIGBL59NyqEriuZXh8u2IekUdI5IAuo+RVxNGnKQVEVUPYhxPmhqxjc8AcozgOvAmfiY9eDHdl0Ee9G1LYkHIlvo=  ;
X-YMail-OSG: 10wgb4kVM1mBUYi4cZ80TKLW1eI.lAhk86SJTxoDBI5P1NzhqpQ8GMBArzbt1yfEsSXt2aF3DpdFFlXnGwmDgBkJrNZBw2Eq83zCLm6CMPota8ePhYerhTpd9NaR4Nu25WrYTRc7yIEXznZgWIsKltKWycsWqeMmWhxPpywB38AgM.H1cdIYY01tOp7M.hgfdtN3u4_QkFFI189poa4bM2quLV26o8g8NW905Z9dEFvrgUTp1w_uu5Q8ygwjw1m0_tZYxFaJyaEqAG_LusTbssO0PABRTWywy2gAg2RZ4_VddMijEEGo
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Izik Eidus <ieidus@redhat.com>
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux v2
Date: Mon, 6 Apr 2009 17:04:49 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       aarcange@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
References: <1238855722-32606-1-git-send-email-ieidus@redhat.com>
In-Reply-To: <1238855722-32606-1-git-send-email-ieidus@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904061704.50052.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009 01:35:18 Izik Eidus wrote:

> This driver is very useful for KVM as in cases of runing multiple guests
> operation system of the same type.
> (For desktop work loads we have achived more than x2 memory overcommit
> (more like x3))

Interesting that it is a desirable workload to have multiple guests each
running MS office.

I wonder, can windows enter a paravirtualised guest mode for KVM? And can
you detect page allocation/freeing events?

 
> This driver have found users other than KVM, for example CERN,
> Fons Rademakers:
> "on many-core machines we run one large detector simulation program per core.
> These simulation programs are identical but run each in their own process and
> need about 2 - 2.5 GB RAM.
> We typically buy machines with 2GB RAM per core and so have a problem to run
> one of these programs per core.
> Of the 2 - 2.5 GB about 700MB is identical data in the form of magnetic field
> maps, detector geometry, etc.
> Currently people have been trying to start one program, initialize the geometry
> and field maps and then fork it N times, to have the data shared.
> With KSM this would be done automatically by the system so it sounded extremely
> attractive when Andrea presented it."

They should use a shared memory segment, or MAP_ANONYMOUS|MAP_SHARED etc.
Presumably they will probably want to control it to interleave it over
all numa nodes and use hugepages for it. It would be very little work.

 
> I am sending another seires of patchs for kvm kernel and kvm-userspace
> that would allow users of kvm to test ksm with it.
> The kvm patchs would apply to Avi git tree.
