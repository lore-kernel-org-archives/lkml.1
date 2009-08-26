Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZHZU3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZHZU3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZHZU3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:29:42 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:7735 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753332AbZHZU3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:29:42 -0400
X-Trace: 252676048/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.42.125/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.42.125
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EALk3lUpPRSp9/2dsb2JhbACBU9cPhBoF
X-IronPort-AV: E=Sophos;i="4.44,281,1249254000"; 
   d="scan'208";a="252676048"
Date: Wed, 26 Aug 2009 21:29:07 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Izik Eidus <ieidus@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Justin M. Forbes" <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 13/12] ksm: fix munlock during exit_mmap deadlock
In-Reply-To: <20090826194444.GB14722@random.random>
Message-ID: <Pine.LNX.4.64.0908262118470.4364@sister.anvils>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
 <Pine.LNX.4.64.0908031317190.16754@sister.anvils> <20090825145832.GP14722@random.random>
 <20090825152217.GQ14722@random.random> <Pine.LNX.4.64.0908251836050.30372@sister.anvils>
 <20090825181019.GT14722@random.random> <Pine.LNX.4.64.0908251958170.5871@sister.anvils>
 <20090825194530.GU14722@random.random> <Pine.LNX.4.64.0908261910530.15622@sister.anvils>
 <20090826194444.GB14722@random.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Andrea Arcangeli wrote:
> On Wed, Aug 26, 2009 at 08:17:50PM +0100, Hugh Dickins wrote:
> > Has anyone looked at why Rawhide's mlockall is not faulting in the
> > pages, I wonder if there's a separate bug there?)
> 
> I reproduced only with self compiled mmotm kernel with full self
> compiled userland with just a mlockall and exit (not rawhide
> kernel/userland) so there's certainly no bug in rawhide, or at least
> nothing special about it.

I just tried again and got it myself: the faulting page is a PROT_NONE
page of libc, yes, that figures: mlocking would not fault it in, but
munlocking would (in its current implementation) insist on faulting it.

I don't know what my difficulty was yesterday: perhaps that page
isn't always PROT_NONE, perhaps I got confused and was testing the
wrong kernel, one without KSM or one with my follow_page munlock.

Hugh
