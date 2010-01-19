Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944Ab0ASMtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0ASMtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441Ab0ASMtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:49:04 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:53925 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab0ASMtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Y4kA5qWiPWNWX8ZsCqjSK6Plj61P86NCfmrfwEM+XKniYRGZcMiHVFynHBvhXzQvKo
         4WXb00JyonbXuVYJ9J6SMvkbv1vJf6FDxNATSEXPvuzG46H28PRr5xkjZKUcgLLXVcVo
         92h0560/I7i4azyPabNbGKHLVuhJ4J3hFeJQc=
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
From: Minchan Kim <minchan.kim@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Gleb Natapov <gleb@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org, andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <84144f021001190044s397c6665qb00af48235d2d818@mail.gmail.com>
References: <20100118141938.GI30698@redhat.com>
	 <20100118170816.GA22111@redhat.com>
	 <84144f021001181009m52f7eaebp2bd746f92de08da9@mail.gmail.com>
	 <20100118181942.GD22111@redhat.com>
	 <20100118191031.0088f49a@lxorguk.ukuu.org.uk>
	 <20100119071734.GG14345@redhat.com>
	 <84144f021001182337o274c8ed3q8ce60581094bc2b9@mail.gmail.com>
	 <20100119075205.GI14345@redhat.com>
	 <84144f021001190007q54a334dfwed64189e6cf0b7c4@mail.gmail.com>
	 <20100119082638.GK14345@redhat.com>
	 <84144f021001190044s397c6665qb00af48235d2d818@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 21:48:52 +0900
Message-ID: <1263905332.2163.11.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Pekka. 

On Tue, 2010-01-19 at 10:44 +0200, Pekka Enberg wrote:
> Hi Gleb,
> 
> On Tue, Jan 19, 2010 at 10:26 AM, Gleb Natapov <gleb@redhat.com> wrote:
> >> design would still be broken, no? Did you try using (or extending)
> >> posix_madvise(MADV_DONTNEED) for the guest address space? It seems to
> > After mlockall() I can't even allocate guest address space. Or do you mean
> > instead of mlockall()? Then how MADV_DONTNEED will help? It just drops
> > page table for the address range (which is not what I need) and does not
> > have any long time effect.
> 
> Oh right, MADV_DONTNEED is no good.
> 
> On Tue, Jan 19, 2010 at 10:26 AM, Gleb Natapov <gleb@redhat.com> wrote:
> >> me that you're trying to use a big hammer (mlock) when a polite hint
> >> for the VM would probably be sufficient for it do its job.
> >>
> > I what to tell to VM "swap this, don't swap that" and as far as I see
> > there is no other way to do it currently.
> 
> Yeah, which is why I was suggesting that maybe posix_madvise() needs
> to be extended to have a MADV_NEED_BUT_LESS_IMPORTANT flag that can be
> used as a hint by mm/vmscan.c to first swap the guest address spaces.
> 
>                         Pekka

Gleb. How about using MADV_SEQUENTIAL on guest memory?
It makes that pages of guest are moved into inactive reclaim list more
fast. It means it is likely to swap out faster than other pages if it
isn't hit during inactive list.


-- 
Kind regards,
Minchan Kim

