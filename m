Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753244AbYLRSWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYLRSWP (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYLRSV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:21:56 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:56731 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYLRSVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:21:55 -0500
Subject: Re: [RFC v11][PATCH 05/13] Dump memory address space
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mike Waychison <mikew@google.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, jeremy@goop.org, arnd@arndb.de,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linux Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <494A9350.1060309@google.com>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
	 <1228498282-11804-6-git-send-email-orenl@cs.columbia.edu>
	 <4949B4ED.9060805@google.com> <494A2F94.2090800@cs.columbia.edu>
	 <494A9350.1060309@google.com>
Content-Type: text/plain
Date: Thu, 18 Dec 2008 10:21:39 -0800
Message-Id: <1229624499.17206.576.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 10:15 -0800, Mike Waychison wrote:
> 
> >>> +    pgarr = kzalloc(sizeof(*pgarr), GFP_KERNEL);
> >>> +    if (!pgarr)
> >>> +        return NULL;
> >>> +
> >>> +    pgarr->vaddrs = kmalloc(CR_PGARR_TOTAL * sizeof(unsigned
> long),
> >> You used PAGE_SIZE / sizeof(void *) above.   Why not
> __get_free_page()?
> > 
> > Hahaha .. well, it's a guaranteed method to keep Dave Hansen from
> > barking about not using kmalloc ...
> > 
> > Personally I prefer __get_free_page() here, but not enough to keep
> > arguing with him. Let me know when the two of you settle it :)
> 
> Alright, I just wasn't sure if it had been considered.

__get_free_page() sucks.  It doesn't do cool stuff like redzoning when
you have slab debugging turned on.  :)

I would personally suggest never using __get_free_page() unless you
truly need a *PAGE*.  That's an aligned, and PAGE_SIZE chunk.  If you
don't need alignment, or don't literally need a 'struct page', don't use
it.

-- Dave

