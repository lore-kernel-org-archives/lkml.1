Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbZANAdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbZANAdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760309AbZANAdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:33:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758388AbZANAdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:33:21 -0500
Date: Tue, 13 Jan 2009 16:33:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mtk.manpages@gmail.com,
       kernel list <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
Subject: Re: [PATCH] sys_waitid: return -EFAULT for NULL
In-Reply-To: <20090113224941.36F19FC3DD@magilla.sf.frob.com>
Message-ID: <alpine.LFD.2.00.0901131629220.6528@localhost.localdomain>
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com> <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com> <20090113224759.7DFB7FC3DD@magilla.sf.frob.com> <20090113224941.36F19FC3DD@magilla.sf.frob.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Jan 2009, Roland McGrath wrote:
>
> It's always been invalid to call waitid() with a NULL pointer.  It was an
> oversight that it was allowed (and acts like a wait4() call instead).

I'm not going to take this. 

If it was some new system call, of if there was some downside to out 
behavior, I might be interested. As it is, our behaviour has zero 
downside, and changing existing interfaces simply isn't worth it.

The alleged "downsides" are bogus:

 - POSIX is not that strict. EFAULT is one of the odd error cases anyway, 
   and even explicit requirements are irrelevant: if somebody wants to get 
   strict conformance paperwork done, you just need to tell where you 
   differ, and you're basically done. But perhaps more important, nobody 
   cares.

 - The "portability" argument is totally bogus, since it's not like you 
   compile programs without even testing to another UNIX _anyway_. 

So I'm simply not going to potentially break binaries over something that 
is so _totally_ irrelevant. Document it in the man-page instead.

		Linus
