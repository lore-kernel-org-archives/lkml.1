Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbYE2Tu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbYE2Tu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYE2TuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:50:19 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:28794 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYE2TuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:50:18 -0400
From: Lee Schermerhorn <lee.schermerhorn@hp.com>
To: linux-kernel@vger.kernel.org
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Eric Whitney <eric.whitney@hp.com>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 29 May 2008 15:50:30 -0400
Message-Id: <20080529195030.27159.66161.sendpatchset@lts-notebook>
Subject: [PATCH 00/25] Vm Pageout Scalability Improvements (V8) - continued
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The patches to follow are a continuation of the V8 "VM pageout scalability
improvements" series that Rik van Riel posted to LKML on 23May08.  These
patches apply atop Rik's series with the following overlap:

Patches 13 through 16 replace the corresponding patches in Rik's posting.

Patch 13, the noreclaim lru infrastructure, now includes Kosaki Motohiro's
memcontrol enhancements to track nonreclaimable pages.

Patches 14 and 15 are largely unchanged, except for refresh.  Includes
some minor statistics formatting cleanup.

Patch 16 includes a fix for an potential [unobserved] race condition during
SHM_UNLOCK.

---

Additional patches in this series:

Patches 17 through 20 keep mlocked pages off the normal [in]active LRU
lists using the noreclaim lru infrastructure.   These patches represent
a fairly significant rework of an RFC patch originally posted by Nick Piggin.

Patches 21 and 22 are optional, but recommended, enhancements to the overall
noreclaim series.  

Patches 23 and 24 are optional enhancements useful during debug and testing.

Patch 25 is a rather verbose document describing the noreclaim lru
infrastructure and the use thereof to keep ramfs, SHM_LOCKED and mlocked
pages off the normal LRU lists.

---

The entire stack, including Rik's split lru patches, are holding up very
well under stress loads.  E.g., ran for over 90+ hours over the weekend on
both x86_64 [32GB, 8core] and ia64 [32GB, 16cpu] platforms without error
over last weekend.  

I think these are ready for a spin in -mm atop Rik's patches.

Lee

