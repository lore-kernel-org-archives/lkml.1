Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbZIZVcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbZIZVcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 17:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZIZVcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 17:32:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51947 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZIZVcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 17:32:04 -0400
Date: Sat, 26 Sep 2009 23:32:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HWPOISON: remove the unsafe __set_page_locked()
Message-ID: <20090926213204.GX30185@one.firstfloor.org>
References: <20090926031537.GA10176@localhost> <Pine.LNX.4.64.0909261115530.12927@sister.anvils> <20090926190645.GB14368@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926190645.GB14368@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a bit tricky to do right now; you have a chicken and egg
> problem between locking the page and pinning the inode mapping.

One possibly simple solution would be to just allocate the page
locked (GFP_LOCKED). When the allocator clears the flags it already
modifies the state, so it could as well set the lock bit too. No
atomics needed.  And then clearing it later is also atomic free.

Would that satisfy the concerns?

Again another way is to just ignore it.

-Andi
