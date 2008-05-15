Return-Path: <linux-kernel-owner+w=401wt.eu-S1762047AbYEOQEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047AbYEOQEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759108AbYEOQEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:04:30 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39882 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758551AbYEOQE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:04:29 -0400
Date: Thu, 15 May 2008 19:02:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCHES] V4L/DVB fixes for 2.6.26
Message-ID: <20080515160245.GA1936@cs181133002.pp.htv.fi>
References: <20080514114910.4bcfd220@gaivota> <20080514165434.GC22115@cs181133002.pp.htv.fi> <20080514145554.10e3385c@gaivota> <20080514193822.GA21795@cs181133002.pp.htv.fi> <20080514170405.330c0d0a@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080514170405.330c0d0a@gaivota>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 05:04:05PM -0300, Mauro Carvalho Chehab wrote:
>...
> > but otherwise that 
> > would be a straightforward solution to solve these problems.
> 
> This will solve several troubles. Still, I think that there are still some
> other missing dependencies (like INPUT, on drivers that select IR).

We could select INPUT from drivers/media/

And FW_LOADER should really select HOTPLUG - there's no good reason for 
FW_LOADER to be a user-visible option with dependencies.

But these two are problems that are only relevant for randconfig users 
while the I2C troubles hit real users, so I want to attack the I2C 
issues first.

> > Any problem I miss or should I bake a patch?
> 
> I can't see any trouble on this approach. Feel free to work on it.

First issue when working on it:

The dependencies between VIDEO_IR and VIDEO_IR_I2C look wrong
(consider VIDEO_IR=y and I2C=m).

It's not a problem since currently all users of VIDEO_IR also depend
on I2C.

Should I fix the dependency or can I let VIDEO_IR select I2C and remove 
VIDEO_IR_I2C?

> Thanks,
> Mauro

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

