Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbYDQTj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbYDQTj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYDQTjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:39:20 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:11333 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYDQTjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wOL4/UYQ1HbX42zJVg+BMTconpMr5oGZ2RV+Bk3BtPV+K1vnEkhlLZElMAGNwn6QErW2JGOJsUbWS+wtUZDWgE8HNQvbCW2IfcS9p8QgatqLGYVUOnJPqljEsrmPHb4WQHhxVTPutrIcUJ+HpaqrO60iP+iLJTc9fWVxzAomsTg=
Message-ID: <19f34abd0804171239v66e5efe6xe887ef89d518baf2@mail.gmail.com>
Date: Thu, 17 Apr 2008 21:39:18 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080417193537.GA6253@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416202338.GA6007@elte.hu> <20080417083000.GA4935@elte.hu>
	 <20080417014054.ea788f1f.akpm@linux-foundation.org>
	 <20080417090626.GA14383@elte.hu>
	 <20080417021813.04df7912.akpm@linux-foundation.org>
	 <20080417093025.GA17389@elte.hu>
	 <20080417023603.672d1032.akpm@linux-foundation.org>
	 <19f34abd0804171147l4403d49aoeab005105a90392b@mail.gmail.com>
	 <20080417192729.GA3058@elte.hu> <20080417193537.GA6253@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 9:35 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Ingo Molnar <mingo@elte.hu> wrote:
>
>
> > > Actually it doesn't. I attach a patch which gets rid of the page flag,
>  > > and we rely instead on the PTE flag for page-trackedness.
>  > [...]
>  > > Ingo, will you take this for some additional testing?
>  >
>  > thanks Vegard, i've applied it - looks good to me too.
>
>  x86.git randconfig testing found a build bug - fix below.
>
>         Ingo
>

Oh, oops. Of course... Thanks, you shouldn't have had to do that :-(

Vegard

>  ------------>
>  Subject: kmemcheck: fix build
>  From: Ingo Molnar <mingo@elte.hu>
>  Date: Thu Apr 17 21:20:43 CEST 2008
>
>  Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  ---
>   include/linux/kmemcheck.h |    3 +++
>   1 file changed, 3 insertions(+)
>
>  Index: linux/include/linux/kmemcheck.h
>  ===================================================================
>  --- linux.orig/include/linux/kmemcheck.h
>  +++ linux/include/linux/kmemcheck.h
>  @@ -1,6 +1,8 @@
>   #ifndef LINUX_KMEMCHECK_H
>   #define LINUX_KMEMCHECK_H
>
>  +#include <linux/types.h>
>  +
>   #ifdef CONFIG_KMEMCHECK
>   extern int kmemcheck_enabled;
>
>  @@ -24,6 +26,7 @@ void kmemcheck_mark_uninitialized_pages(
>   #ifndef CONFIG_KMEMCHECK
>   #define kmemcheck_enabled 0
>   static inline void kmemcheck_init(void) { }
>  +static inline bool kmemcheck_page_is_tracked(struct page *p) { return false; }
>   #endif /* CONFIG_KMEMCHECK */
>
>   #endif /* LINUX_KMEMCHECK_H */
>



-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
