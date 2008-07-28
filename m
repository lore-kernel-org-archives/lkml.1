Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbYG1QSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbYG1QSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758890AbYG1QSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:18:04 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41723 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756637AbYG1QSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:18:03 -0400
Subject: Re: [PATCH 1/1] mm: unify pmd_free() implementation
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Righi <righi.andrea@gmail.com>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807280851130.3486@nehalem.linux-foundation.org>
References: <> <1217260287-13115-1-git-send-email-righi.andrea@gmail.com>
	 <alpine.LFD.1.10.0807280851130.3486@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 11:17:32 -0500
Message-Id: <1217261852.3503.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 08:53 -0700, Linus Torvalds wrote:
> But this is horrible, because it forces a totally unnecessary function 
> call for that empty function.
> 
> Yeah, the function will be cheap, but the call itself will not be (it's a 
> C language barrier and basically disables optimizations around it, causing 
> thigns like register spill/reload for no good reason).

Are you sure about this (the barrier)?  We've been struggling to find a
paradigm for our trace points but the consensus seemed to be that
compiler barriers were pretty tiny perturbations in the optimiser stream
(they affect calculation ordering, but not usually enough to be
noticed).  The register spills to get known locations for the tracepoint
variables seemed to be the much more expensive thing.

If this basic assumption is wrong, we need to know now ...

James


