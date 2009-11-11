Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbZKKKsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbZKKKsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 05:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbZKKKsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 05:48:08 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:55414 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755694AbZKKKsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 05:48:07 -0500
X-Trace: 284228141/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.12.20/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.12.20
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvQAAGol+kpQKQwU/2dsb2JhbAAI3BOEPAQ
X-IronPort-AV: E=Sophos;i="4.44,722,1249254000"; 
   d="scan'208";a="284228141"
Date: Wed, 11 Nov 2009 10:48:07 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/6] mm: CONFIG_MMU for PG_mlocked
In-Reply-To: <20091111101315.FD33.A69D9226@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0911111042400.12126@sister.anvils>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils>
 <Pine.LNX.4.64.0911102155180.2816@sister.anvils> <20091111101315.FD33.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009, KOSAKI Motohiro wrote:
> > Remove three degrees of obfuscation, left over from when we had
> > CONFIG_UNEVICTABLE_LRU.  MLOCK_PAGES is CONFIG_HAVE_MLOCKED_PAGE_BIT
> > is CONFIG_HAVE_MLOCK is CONFIG_MMU.  rmap.o (and memory-failure.o)
> > are only built when CONFIG_MMU, so don't need such conditions at all.
> 
> I don't recall why Lee added this config option. but it seems very
> reasonable and I storongly like it.
> 
> At least, vmscan folks never said "please try to disable CONFIG_MLOCK".
> It mean this option didn't help our debug.
> 
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thanks.  CONFIG_HAVE_MLOCKED_PAGE_BIT and CONFIG_HAVE_MLOCK were both
just internal, automatically defaulted options which the user never
saw (except in .config).  I think they were there to sort out the
interdependencies between CONFIG_MMU and CONFIG_UNEVICTABLE_LRU,
and probably other historical issues while people decided whether
or not to go ahead with having a page bit for the thing.  So no
user should notice their disappearance: removing them just makes
the code clearer, that's all.

Hugh
