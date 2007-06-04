Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbXFDOyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbXFDOyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbXFDOyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:54:01 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4277 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXFDOyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:54:00 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 4 Jun 2007 07:53:55 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
In-Reply-To: <20070604162855.f98d1698.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0706040743060.30836@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
 <46633047.1020707@cosmosbay.com> <Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
 <20070603230859.5000424d.akpm@linux-foundation.org> <20070604080537.GA22898@elte.hu>
 <20070604080941.GA23537@elte.hu> <20070604013449.ea3acca8.akpm@linux-foundation.org>
 <20070604122857.1399e3fc.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706040523150.30231@alien.or.mcafeemobile.com>
 <20070604152540.985c186a.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706040633360.30231@alien.or.mcafeemobile.com>
 <20070604162855.f98d1698.dada1@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Eric Dumazet wrote:

> On Mon, 4 Jun 2007 06:35:16 -0700 (PDT)
> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > On Mon, 4 Jun 2007, Eric Dumazet wrote:
> > 
> > > You add conditional branches on very hot spots.
> > 
> > Keep BS for the ones you argue usually, and that are not able to reply.
> > You *still* two bitmaps, because allocation spaces are far apart. So the 
> > "if" will still be there.
> 
> I actually read your patches and spent time to see the pros and cons.
> 
> If you dont need reviewers, please dont post your patches on lkml.

I *do like* reviews, and if you go back in all the reviews my code had 
during the last few months for example, you'll notice that I *almost always*
ACK the reviewers suggestions. I'm a believer that in computer science, 
there are many ways to do the same thing, and many of those are very close 
as far as pros&cons. So, if some reviewer suggests me something, I'm 
inclined to ACK it, even if the solution I wrote (or that I had in mind) 
was different.
In this case though, your solution and mine are *really* different. You 
are trying to fit a structure to a problem that is not meant to. And it is 
so clearly evident, that it blows my mind how this could even be argued.
As I said to Andrew, we can use fdmap for both allocations (fdmap already 
supports all the allocation modes the current fdtable does - modulo adding 
a bitmap), and cut a lot of code out.
This is the way I'm currently heading, so all the code from fs/file.c (256 
lines) can go. locate_fd will go. set_close_on_exec and get_close_on_exec 
will use the existing function in fdmap.c, etc...



> If I am not mistaken, you added a test in fget()/fget_light(), which is 
> a known hot point for said huge processes.

There is one "if", that you cannot avoid, since allocation areas are far 
apart (and one of them is even random). Unless you plan to have a single 
contiguous bitmap with *a lot* of wasted space in the middle.



- Davide


