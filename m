Return-Path: <linux-kernel-owner+w=401wt.eu-S932161AbZDDB5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbZDDB5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 21:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762198AbZDDB5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 21:57:36 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:64865 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbZDDB5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 21:57:35 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Subject: [PATCH V2 0/7] swiotlb: changes for powerpc/highmem
Date: Fri,  3 Apr 2009 20:56:42 -0500
Message-Id: <1238810209-24499-1-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of a series of fairly minor patches that get swiotlb
working on 32-bit powerpc systems with HIGHMEM, plus some cleanup
of the outdated comments in the code. I've made a couple of things
weak that ppc needs to override, and have changed the prototypes
for a couple of functions to include the hwdev pointer, which
we need to ppc to convert bus addresses to and from phys/virt
addresses. I've also fixed a build warning I've been seeing on
ppc.

In response to commentary on the previous series, I've also
refactored the code a bit, altough I did this slightly
differently than was suggested because I noticed we could use the
new helper function in 2 places instead of one. I've reformatted
a bit of code based on commentary as well.

I have not tested this in any way on any non-ppc platforms,
so commentary/testing from x86/ia64 folks is, once again,
greatly appreciated.

I'm going to be offline for the next week, but will respond to
commentary as soon as I return.

Cheers,
Becky

diffstat:
arch/x86/kernel/pci-swiotlb.c |    2 +-
include/linux/swiotlb.h       |    3 +-
lib/swiotlb.c                 |  115 ++++++++++++++++++++++-------------------
3 files changed, 64 insertions(+), 56 deletions(-)

