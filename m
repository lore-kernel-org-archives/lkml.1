Return-Path: <linux-kernel-owner+w=401wt.eu-S1759341AbYEWVpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341AbYEWVpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 17:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbYEWVpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 17:45:05 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:36959 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbYEWVpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 17:45:04 -0400
Subject: Re: [ofa-general] Re: linux-next: [PATCH]
	infiniband/hw/ipath/ipath_sdma.c , fix compiler warnings
From: Ralph Campbell <ralph.campbell@qlogic.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, general@lists.openfabrics.org
In-Reply-To: <adave14apdr.fsf@cisco.com>
References: <48342C6C.2010502@googlemail.com>  <adave14apdr.fsf@cisco.com>
Content-Type: text/plain
Organization: QLogic
Date: Fri, 23 May 2008 14:45:01 -0700
Message-Id: <1211579101.3949.326.camel@brick.pathscale.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 May 2008 21:44:57.0418 (UTC) FILETIME=[3E6EDAA0:01C8BD1E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks good to me.

On Fri, 2008-05-23 at 10:42 -0700, Roland Dreier wrote:
>  > drivers/infiniband/hw/ipath/ipath_sdma.c: In function 'sdma_abort_task':
>  > drivers/infiniband/hw/ipath/ipath_sdma.c:267: warning: passing argument 2 of 'constant_test_bit' from incompatible pointer type
> 
> Perhaps the best way to fix these is to change code like
> 
> 		if (/* ScoreBoardDrainInProg */
> 		    test_bit(63, &hwstatus) ||
> 		    /* AbortInProg */
> 		    test_bit(62, &hwstatus) ||
> 		    /* InternalSDmaEnable */
> 		    test_bit(61, &hwstatus) ||
> 		    /* ScbEmpty */
> 		    !test_bit(30, &hwstatus)) {
> 
> to something like
> 
> 		if ((hwstatus & (IPATH_SDMA_STATUS_SCORE_BOARD_DRAIN_IN_PROG |
> 				 IPATH_SDMA_STATUS_ABORT_IN_PROG	     |
> 				 IPATH_SDMA_STATUS_INTERNAL_SDMA_ENABLE)) ||
> 		    !(hwstatus & IPATH_SDMA_STATUS_SCB_EMPTY)) {
> 
> with appropriate defines for the constants 1ull << 63 etc.
> 
> (I think I got the logic correct but someone should check)
> 
>  > drivers/infiniband/hw/ipath/ipath_sdma.c:348: warning: format '%016llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'
>  > drivers/infiniband/hw/ipath/ipath_sdma.c: In function 'ipath_restart_sdma':
>  > drivers/infiniband/hw/ipath/ipath_sdma.c:618: warning: format '%016llx' expects type 'long long unsigned int', but argument 3 has type 'long unsigned int'
> 
> I have a fix for this pending; will ask Linus to pull today.
> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
> 
> To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-general

