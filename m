Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbYIWDQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbYIWDQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 23:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYIWDQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 23:16:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57782
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754407AbYIWDQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 23:16:22 -0400
Date: Mon, 22 Sep 2008 20:16:10 -0700 (PDT)
Message-Id: <20080922.201610.246167553.davem@davemloft.net>
To: npiggin@suse.de
Cc: benh@kernel.crashing.org, jeremy@goop.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, hugh@veritas.com
Subject: Re: PTE access rules & abstraction
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080923031037.GA11907@wotan.suse.de>
References: <48D739B2.1050202@goop.org>
	<1222117551.12085.39.camel@pasglop>
	<20080923031037.GA11907@wotan.suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>
Date: Tue, 23 Sep 2008 05:10:37 +0200

> Part of the problem with the pte API (as well as the cache flush and
> tlb flush APIs) is that it often involves the core mm code telling
> the arch how it thinks ptes,tlbs,caches should be managed, rather than
> I think the better approach would be telling the arch what it wants to
> do.
> 
> We are getting better slowly I think (eg. you note that set_pte_at is
> no longer used as a generic "do anything"), but I won't dispute that
> this whole area could use an overhaul; a document for all the rules,
> a single person or point of responsibility for those rules...

I agree.

To a certain extent this is what BSD does in it's pmap layer, except
that they don't have the page table datastructure abstraction like
Linus does in the generic code, and which I think was a smart design
decision on our side.

All of the pmap modules in BSD are pretty big and duplicate a lot of
code that arch's don't have to be mindful about under Linux.
