Return-Path: <linux-kernel-owner+w=401wt.eu-S1762163AbXGaNdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163AbXGaNdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbXGaNdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:33:00 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:4504 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbXGaNc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:32:59 -0400
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Date: Tue, 31 Jul 2007 14:32:44 +0100
User-Agent: KMail/1.9.5
Cc: "Matthew Hawkins" <darthmdh@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070731094526.GA16300@elte.hu> <b21f8390707310616o1ac04f15r7f84023ca773008e@mail.gmail.com>
In-Reply-To: <b21f8390707310616o1ac04f15r7f84023ca773008e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707311432.45214.elmig@debianpt.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Terça, 31 de Julho de 2007 14:16, Matthew Hawkins escreveu:
> On 7/31/07, Ingo Molnar <mingo@elte.hu> wrote:
> > * Kenneth Prugh <ken69267@gmail.com> wrote:
> > > CFS generally seemed a lot smoother as the load increased, while SD
> > > broke down to a highly unstable fps count that fluctuated massively
> > > around the third loop. Seems like I will stick to CFS for gaming now.
>
> My experience was quite similar.  I noticed after launching the second
> loop that the FPS stuck down to 15 for about 20 seconds, then climbed
> back up to 48.  After that it went rapidly downhill.  This is similar
> to other benchmarks I've done of SD versus CFS in the past.  At a
> "normal" load they're fairly similar but SD breaks down under
> pressure.
> The only other thing of interest is that the -ck kernel had the WM
> menus appear in about 3 seconds rather than 5-8 under the other two.
>
> Game: Nexuiz 2.3
> OpenGL 2.0 shaders on
> Vertex Buffer Objects on
> Show FPS on
> ultimate quality
> 1024x768
>
> 2.6.23-git
> 0 48
> 1 48
> 2 48
> 3 48
> 4 40
> 5 38
> 6 33
> 7 28
> 8 22
> 9 22
> 10 18
>
> 2.6.22.1-ck
> 0 48
> 1 48
> 2 48
> 3 12
> 4 6
> 5 6
> 6 5
> 7 4
> 8 3
> 9 3
> 10 2
>
> 2.6.22.1-cfs-v19.1+ckbits [*]
> 0 48
> 1 48
> 2 48
> 3 46
> 4 45
> 5 43
> 6 36
> 7 32
> 8 25
> 9 24
> 10 24
>
> [*] This kernel has the cfq-* and mm-* patches from -ck applied, and
> the above-background-load function from pre-SD ck patchsets (or
> 2.6.23-git)


CFS does not requeue_task() on SCHED_YIELD (used by graphic drivers) as until 
2.6.22 and -ck. Please try this hack [1] that makes -ck to behave like CFS 
then you are comparing apples to apples.

Details on the SCHED_YIELD implementation on [2]. Please correct it if it's 
wrong.

1 - http://www.debianpt.org/~elmig/pool/kernel/20070731/sched_yield_hack.patch
2 - http://bhhdoa.org.au/pipermail/ck/2007-July/008297.html

-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org
