Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbXEZK3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbXEZK3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 06:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbXEZK3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 06:29:14 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:60253 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbXEZK3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 06:29:13 -0400
Subject: Re: [RFC] LZO de/compression support - take 4
From: Richard Purdie <richard@openedhand.com>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm-cc@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Satyam Sharma <satyam.sharma@gmail.com>, Andrey Panin <pazke@donpac.ru>,
       Bret Towe <magnade@gmail.com>, Michael-Luke Jones <mlj28@cam.ac.uk>
In-Reply-To: <4cefeab80705250557w1baee0afn255e37436b6545a@mail.gmail.com>
References: <4cefeab80705250445m51736a9aj8c89af893d8c242c@mail.gmail.com>
	 <1180095000.5864.48.camel@localhost.localdomain>
	 <4cefeab80705250557w1baee0afn255e37436b6545a@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 26 May 2007 11:28:45 +0100
Message-Id: <1180175325.5856.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

On Fri, 2007-05-25 at 18:27 +0530, Nitin Gupta wrote:
> On 5/25/07, Richard Purdie <richard@openedhand.com> wrote:
> > On Fri, 2007-05-25 at 17:15 +0530, Nitin Gupta wrote:
> > > Richard, can you please provide perf. results for this patch also?
> > > Also, can you please mail back latest version of your LZO patch? In
> > > meantime, I will try to include benchmarking support to the
> > > 'compress-test' module.
> >
> > This version is 15% slower at decompression and about equal on
> > compression.
> >
> 
> If you don't mind, can you please try patch attached now? I have now
> also rolled back that cpu_to_le16() change as Satyam suggested. I see
> no other reason for this perf. loss as I made no other change!
> 
> Also, can you please verify if you are comparing your _safe_ version
> with this patch? This patch does not include unsafe version and the
> safe one is simply called lzo1x_decompress().

I've been looking at my benchmark figures and I think I've found why the
figures for my version were different to yours. Its not your code which
is at fault, its the way it was hooked into the benchmarking program.
The compiler was inlining some parts which it shouldn't have been
allowed to do, sorry :-/.

With that issue corrected, decompression is the same speed however
compression is showing about a 9% performance loss compared to my kernel
patch.

I did some diffs of the assembler outputted by our two versions (mine
matches minilzo). For decompression the output is effectively identical.
For compression, there are significant differences. If I add a noinline
attribute to lzo1x_compress_worker, that removes a lot of them (and
boosts speed a bit) but there are still differences. Ideally, I'd like
to understand why.

Regards,

Richard


