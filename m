Return-Path: <linux-kernel-owner+w=401wt.eu-S1762761AbXJXQ4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762761AbXJXQ4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762096AbXJXQkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:40:47 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49922 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762101AbXJXQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:40:45 -0400
Date: Wed, 24 Oct 2007 18:41:13 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/cgroup.c: make 2 functions static
Message-ID: <20071024164113.GX30533@stusta.de>
References: <20071024162339.GT30533@stusta.de> <6599ad830710240932s57656f04y2d753453ce590707@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6599ad830710240932s57656f04y2d753453ce590707@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 09:32:26AM -0700, Paul Menage wrote:
> On 10/24/07, Adrian Bunk <bunk@kernel.org> wrote:
> > cgroup_is_releasable() and notify_on_release() should be static,
> > not global inline.
> >
> 
> They seem like they could be usefully static inline - or will the
> compiler inline them anyway since they're simple enough?

gcc [1] will currently always inline a static cgroup_is_releasable() as 
long as it only has one caller.

Besides this, the compiler has the opportunity to inline all static 
functions when it thinks this makes sense, and it can base it's decision 
on things like whether we gave it -Os/-O2 and which CPU it's compiling 
for.

Long term manually forced "inline" has negative effects since functions 
tend to become larger and more often called without the "inline" 
removed, so don't use it unless there is a visible performance 
difference.

> Paul

cu
Adrian

[1] I'm talking about gcc 4

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

