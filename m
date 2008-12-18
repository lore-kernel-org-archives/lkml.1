Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752956AbYLRUBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbYLRUBQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYLRUA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:00:58 -0500
Received: from brinza.cc.columbia.edu ([128.59.29.8]:47504 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYLRUA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:00:57 -0500
Message-ID: <494AABDB.80408@cs.columbia.edu>
Date: Thu, 18 Dec 2008 15:00:27 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Mike Waychison <mikew@google.com>, jeremy@goop.org, arnd@arndb.de,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linux Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v11][PATCH 05/13] Dump memory address space
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>	 <1228498282-11804-6-git-send-email-orenl@cs.columbia.edu>	 <4949B4ED.9060805@google.com>  <494A2F94.2090800@cs.columbia.edu> <1229615676.17206.518.camel@nimitz>
In-Reply-To: <1229615676.17206.518.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dave Hansen wrote:
> On Thu, 2008-12-18 at 06:10 -0500, Oren Laadan wrote:
>>>> +    for (i = pgarr->nr_used; i--; /**/)
>>>> +        page_cache_release(pgarr->pages[i]);
>>> This is sorta hard to read (and non-intuitive).  Is it easier to do:
>>>
>>> for (i = 0; i < pgarr->nr_used; i++)
>>>     page_cache_release(pgarr->pages[i]);
>>>
>>> It shouldn't matter what order you release the pages in..
>> Was meant to avoid a dereference to 'pgarr->nr_used' in the comparison.
>> (though I doubt if the performance impact is at all visible)
> 
> That's a bit to aggressive an optimization.  You two piqued my
> curiosity, so I tried a little experiment with this .c file:
> 
> extern void bar(int i);
> 
> struct s {
>         int *array;
>         int size;
> };
> 
> extern struct s *s;
> void foo(void)
> {
>         int i;
> #ifdef OREN
>         for (i = s->size; i--; )
> #else
>         for (i = 0; i < s->size; i++)
> #endif
>                 bar(s->array[i]);
> }
> 
> for O in "" -O -O1 -O2 -O3 -Os; do
> 	gcc -DOREN $O -c f1.c -o oren.o;
> 	gcc $O -c f1.c -o mike.o;
> 	echo -n Oren:; objdump -d oren.o | grep ret;
> 	echo -n Mike:; objdump -d mike.o | grep ret;
> done

For what it's worth, the idea was to improve time... (not code length).
I changed the code anyway (in response to another comment).

Oren.

