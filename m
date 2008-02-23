Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbYBWRxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbYBWRxM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYBWRw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:52:56 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:47810 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbYBWRwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:52:55 -0500
Date: Sat, 23 Feb 2008 18:53:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, mm-commits@vger.kernel.org,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: Lump xxxinit together with init if possible (was Re: Solve section mismatch for free_area_init_core.)
Message-ID: <20080223175306.GA15186@uranus.ravnborg.org>
References: <20080203172148.GA17875@mailshack.com> <20080218210115.GA24592@uranus.ravnborg.org> <Pine.LNX.4.64.0802190930320.25052@anakin> <20080223163058.GA11003@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223163058.GA11003@mailshack.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander.
> I more than less expected people to scream "ugly, ugly!".

That was my first thought and the reason why it stayed in my inbox
for so long.
But I could not find a better way to do it. We could do it in
different ways but not better.

> Maybe you could consider the following patch, instead?
> In non-HOTPLUG configurations, devinit and init sections in vmlinux
> are lumped together during the final link. There is no good reason
> to warn about section mismatches between them in this case, because
> all code is discarded at the same time. This patch moves the lumping-
> together to the compile stage, which makes the unnecessary warnings
> go away. Same for MEMORY_HOTPLUG/meminit and HOTPLUG_CPU/cpuinit.

>From the commit where the seperate section were introduced:

    Introducing separate sections for __dev* (HOTPLUG),
    __cpu* (HOTPLUG_CPU) and __mem* (MEMORY_HOTPLUG)
    allows us to do a much more reliable Section mismatch
    check in modpost. We are no longer dependent on the actual
    configuration of for example HOTPLUG.

I think that explains it.

	Sam
