Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbZFLMjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbZFLMjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZFLMje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:39:34 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:21661
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783AbZFLMjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:39:33 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2009 08:39:32 EDT
X-IronPort-AV: E=Sophos;i="4.42,209,1243807200"; 
   d="scan'208";a="41643759"
Message-ID: <4A324A4E.1060405@inria.fr>
Date: Fri, 12 Jun 2009 14:30:06 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
CC: "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Lee.Schermerhorn@hp.com, linux-numa@vger.kernel.org,
       Boris Bierbaum <boris@lfbs.rwth-aachen.de>
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de> <87zldjn597.fsf@basil.nowhere.org> <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de> <20090612103251.GJ25568@one.firstfloor.org> <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
In-Reply-To: <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Lankes wrote:
> He enables the support of migration-on-fault via cpusets (echo 1 >
> /dev/cpuset/migrate_on_fault).
> Afterwards, every process could initiate migration-on-fault via mbind(...,
> MPOL_MF_MOVE|MPOL_MF_LAZY).

So mbind(MPOL_MF_LAZY) is taking care of changing page protection so as
to generate page-faults on next-touch? (instead of your madvise)
Is it migrating the whole memory area? Or only single pages?

Then, what's happening with MPOL_MF_LAZY in the kernel? Is it actually
stored in the mempolicy? If so, couldn't another fault later cause
another migration?
Or is MPOL_MF_LAZY filtered out of the policy once the protection of all
PTE has been changed?
I don't see why we need a new mempolicy here. If we are migrating single
pages, migrate-on-next-touch looks like a page-attribute to me. There
should be nothing to store in a mempolicy/VMA/whatever.

Brice

