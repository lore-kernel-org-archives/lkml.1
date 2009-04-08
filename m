Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbZDHGtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbZDHGtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZDHGtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:49:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56806 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZDHGtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:49:05 -0400
Date: Wed, 8 Apr 2009 08:51:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [3/16] POISON: Handle poisoned pages in page free
Message-ID: <20090408065121.GI17934@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407150959.C099D1D046E@basil.firstfloor.org> <28c262360904071621j5bdd8e33u1fbd8534d177a941@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28c262360904071621j5bdd8e33u1fbd8534d177a941@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >        /*
> > +        * Page may have been marked bad before process is freeing it.
> > +        * Make sure it is not put back into the free page lists.
> > +        */
> > +       if (PagePoison(page)) {
> > +               /* check more flags here... */
> 
> How about adding WARNING with some information(ex, pfn, flags..).

The memory_failure() code is already quite chatty. Don't think more
noise is needed currently.

Or are you worrying about the case where a page gets corrupted
by software and suddenly has Poison bits set? (e.g. 0xff everywhere).
That would deserve a printk, but I'm not sure how to reliably test for
that. After all a lot of flag combinations are valid.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
