Return-Path: <linux-kernel-owner+w=401wt.eu-S1763327AbZDHJjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763327AbZDHJjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZDHJjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:39:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36849 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbZDHJjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:39:42 -0400
Date: Wed, 8 Apr 2009 11:41:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [3/16] POISON: Handle poisoned pages in page free
Message-ID: <20090408094159.GK17934@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407150959.C099D1D046E@basil.firstfloor.org> <28c262360904071621j5bdd8e33u1fbd8534d177a941@mail.gmail.com> <20090408065121.GI17934@one.firstfloor.org> <28c262360904080039l65c381edn106484c88f1c5819@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28c262360904080039l65c381edn106484c88f1c5819@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 04:39:17PM +0900, Minchan Kim wrote:
> On Wed, Apr 8, 2009 at 3:51 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >> >
> >> >        /*
> >> > +        * Page may have been marked bad before process is freeing it.
> >> > +        * Make sure it is not put back into the free page lists.
> >> > +        */
> >> > +       if (PagePoison(page)) {
> >> > +               /* check more flags here... */
> >>
> >> How about adding WARNING with some information(ex, pfn, flags..).
> >
> > The memory_failure() code is already quite chatty. Don't think more
> > noise is needed currently.
> 
> Sure.
> 
> > Or are you worrying about the case where a page gets corrupted
> > by software and suddenly has Poison bits set? (e.g. 0xff everywhere).
> > That would deserve a printk, but I'm not sure how to reliably test for
> > that. After all a lot of flag combinations are valid.
> 
> I misunderstood your code.
> That's because you add the code in bad_page.
> 
> As you commented, your intention was to prevent bad page from returning buddy.
> Is right ?

Yes. Well actually it should not happen anymore. Perhaps I should
make it a BUG()

> If it is right, how about adding prevention code to free_pages_check ?
> Now, bad_page is for showing the information that why it is bad page
> I don't like emergency exit in bad_page.

There's already one in there, so i just reused that one. It was a convenient
way to keep things out of the fast path

-Andi

ak@linux.intel.com -- Speaking for myself only.
