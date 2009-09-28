Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZI1BTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZI1BTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 21:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZI1BTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 21:19:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40029 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZI1BTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 21:19:43 -0400
Date: Mon, 28 Sep 2009 03:19:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HWPOISON: remove the unsafe __set_page_locked()
Message-ID: <20090928011943.GB1656@one.firstfloor.org>
References: <20090926031537.GA10176@localhost> <Pine.LNX.4.64.0909261115530.12927@sister.anvils> <20090926190645.GB14368@wotan.suse.de> <20090926213204.GX30185@one.firstfloor.org> <Pine.LNX.4.64.0909271714370.9097@sister.anvils> <20090927192251.GB6327@wotan.suse.de> <Pine.LNX.4.64.0909272251180.4402@sister.anvils> <20090927230118.GH6327@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927230118.GH6327@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is no real rush AFAIKS to fix this one single pagecache site
> while we have problems with slab allocators and all other unaudited
> places that nonatomically modify page flags with an elevated

hwpoison ignores slab pages.

> page reference ... just mark HWPOISON as broken for the moment, or
> cut it down to do something much simpler I guess?

Erm no. These cases are *EXTREMLY* unlikely to hit.

I'll look into exploiting the ordering of the mapping assignment.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
