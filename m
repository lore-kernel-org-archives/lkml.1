Return-Path: <linux-kernel-owner+w=401wt.eu-S1764637AbXGaP5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764637AbXGaP5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbXGaP5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:57:35 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:31548 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbXGaP5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MCFc9Mg8RJ/vu9xAg+L4MV6rTdlGmviEkhQecaEpYFPY1noSx9GWGdZzOI0r7MG5Bzb/Qp9NeuiyRbqTNidJmN1qblKeVZFymzVlUagLAmk0sTpelT5pR8mAPL1jYdWKda8EM3vIitXHk6G8TxtsMON6DNgw9MJgpY0iI8Akch0=
Message-ID: <b21f8390707310857q7d878fe1yc5351cce2cc74248@mail.gmail.com>
Date: Wed, 1 Aug 2007 01:57:33 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: "Miguel Figueiredo" <elmig@debianpt.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Cc: ck@vds.kolivas.org, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Kasper Sandberg" <lkml@metanurb.dk>
In-Reply-To: <200707311432.45214.elmig@debianpt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <20070731094526.GA16300@elte.hu>
	 <b21f8390707310616o1ac04f15r7f84023ca773008e@mail.gmail.com>
	 <200707311432.45214.elmig@debianpt.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Miguel Figueiredo <elmig@debianpt.org> wrote:
> CFS does not requeue_task() on SCHED_YIELD (used by graphic drivers) as until
> 2.6.22 and -ck. Please try this hack [1] that makes -ck to behave like CFS
> then you are comparing apples to apples.

Hi Miguel,

I tested with sched_yield_ctl set to 1

2.6.22.1-ck+sched_yield_hack
0   51
1   51
2   51
3   46
4   38
5   38
6   38
7   30
8   27
9   22
10   20

After getting the numbers on all setups with the 10 loops still
running I went for a run around the map (I used the "aggressor" map,
if anyone cares).  CFS was noticeably smoother (despite the small
framerate differences).  ie CFS was bordering on barely playable,
whereas the above test it wasn't really playable (felt like playing on
a lagged server).  Even plain -ck was better (going for a run, the FPS
jumped from ~2 to 15).  I've noticed messing with sched_yield tends to
cause strange defects in the past...

-- 
Matt
