Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZFLNV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZFLNV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZFLNVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:21:19 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:36803 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbZFLNVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:21:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.42,209,1243807200";   d="scan'208";a="8034999"
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
To: "'Brice Goglin'" <Brice.Goglin@inria.fr>
Cc: "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Lee.Schermerhorn@hp.com, linux-numa@vger.kernel.org,
       Boris Bierbaum <boris@lfbs.rwth-aachen.de>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
 <87zldjn597.fsf@basil.nowhere.org>
 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
 <20090612103251.GJ25568@one.firstfloor.org>
 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de> <4A324A4E.1060405@inria.fr>
In-reply-to: <4A324A4E.1060405@inria.fr>
Subject: RE: [RFC PATCH 0/4]: affinity-on-next-touch
Date: Fri, 12 Jun 2009 15:21:15 +0200
Organization: Chair for Operating Systems, RWTH Aachen University
Message-id: <004501c9eb60$a9abb4c0$fd031e40$@rwth-aachen.de>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcnrWXHDyy/c1RqIQvS1JLHUD9yOpQAAVQdA
Content-language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So mbind(MPOL_MF_LAZY) is taking care of changing page protection so as
> to generate page-faults on next-touch? (instead of your madvise)
> Is it migrating the whole memory area? Or only single pages?

mbind removes the pte references. Page migration will occur, when a task
access to one of these unmapped pages. Therefore, Lee's solution migrate one
single page and not the whole area.

You find further information at slides 19-23 of
http://mirror.linux.org.au/pub/linux.conf.au/2007/video/talks/197.pdf. 

> Then, what's happening with MPOL_MF_LAZY in the kernel? Is it actually
> stored in the mempolicy? If so, couldn't another fault later cause
> another migration?
> Or is MPOL_MF_LAZY filtered out of the policy once the protection of
> all
> PTE has been changed?
>
> I don't see why we need a new mempolicy here. If we are migrating
> single
> pages, migrate-on-next-touch looks like a page-attribute to me. There
> should be nothing to store in a mempolicy/VMA/whatever.
> 

MPOL_MF_LAZY is used as flag and does not specify a new policy. Therefore,
MPOL_MF_LAZY isn't stored in a VMA. The flag is only used to detect that the
system call mbind has to unmap these pages.

Stefan

