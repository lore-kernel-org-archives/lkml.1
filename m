Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbXGDXm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbXGDXm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 19:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbXGDXmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 19:42:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3707 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbXGDXmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 19:42:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 4 Jul 2007 16:42:47 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andy Isaacson <adi@hexapodia.org>
cc: Rik van Riel <riel@redhat.com>, Ulrich Drepper <drepper@gmail.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] MAP_NOZERO v2 - VM_NOZERO/MAP_NOZERO early summer
 madness
In-Reply-To: <20070704215353.GW9157@hexapodia.org>
Message-ID: <Pine.LNX.4.64.0707041630320.9143@alien.or.mcafeemobile.com>
References: <D65DCB84-F812-4C3B-8E68-EACA0CA8A0C0@mac.com>
 <Pine.LNX.4.64.0706291711320.31176@alien.or.mcafeemobile.com>
 <8F40BE4A-BD38-4C3F-B77D-35661E84C553@mac.com>
 <Pine.LNX.4.64.0706301652050.2957@alien.or.mcafeemobile.com>
 <B04FEDC9-A315-4374-843E-DD81E52C5772@mac.com> <20070702190043.GN9157@hexapodia.org>
 <46894BE6.1040302@redhat.com> <a36005b50707021206t417d69ddqcaa8d140e24fa3e3@mail.gmail.com>
 <Pine.LNX.4.64.0707021540560.14774@alien.or.mcafeemobile.com>
 <4689826C.5050800@redhat.com> <20070704215353.GW9157@hexapodia.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007, Andy Isaacson wrote:

> On Mon, Jul 02, 2007 at 06:55:40PM -0400, Rik van Riel wrote:
> > You could easily replace the cookie with a pointer to a free
> > page pool.
> 
> It just occurred to me that something like this is *required* to get the
> performance benefit from MAP_NOZERO on a busy system.  With Davide's
> current proposal, if there are N jobs with different "nozero cookies"
> busy allocating and deallocating pages on a single-NUMA-node system,
> then there's only a 1/N chance that the page returned by __alloc_pages
> will have the correct cookie, so (N-1)/N percent of the time MAP_NOZERO
> will have no positive effect -- 90% of the time for the case of N=10.

That can indeed happen. If you have a system busy with pressure coming 
from many different users, the recycle efficency goes down proportionally 
with it.
As I said before, I prefer a smaller and less intrusive code that gives 
good recycle efficency for the mejority of systems, WRT the idea of 
dedicated pools.
But maybe I'm wrong, and Rik or you can show up with a patch implementing 
pools that does not hurt code, structure sizes and performances.



> In a mostly unrelated complaint, I note that having a function named
> "alloc_zeroed_page_vma" which returns a potentially nonzero page is, um,
> unintuitive.  It needs a name which does not claim it returns zeroed
> pages.  I'm no good at names, but perhaps "alloc_available_page_vma"?

Yeah, the name "zeroed" is not perfect, but neither it is "available". The 
name should give the idea that the page is either from the same ID/cookie 
or it is zeroed. That naming should be applied back to 
alloc_zeroed_user_highpage(), __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE, ...



- Davide


