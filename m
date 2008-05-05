Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbYEEUfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbYEEUfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYEEUfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:35:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbYEEUe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:34:59 -0400
Date: Mon, 5 May 2008 16:34:23 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de
Subject: Re: [patch, -git] media/video/sound build fix, TEA5761/TEA5767
In-Reply-To: <20080502150645.GA23481@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0805051625090.3218@bombadil.infradead.org>
References: <20080430110115.GA5633@elte.hu> <s5hiqxzwqak.wl%tiwai@suse.de>
 <20080430.041703.89847530.davem@davemloft.net> <20080430112959.GA32556@uranus.ravnborg.org>
 <20080430121854.GC30735@elte.hu> <20080502150645.GA23481@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which is exactly what my "require SYMBOL2 would give us.
> A webcam would not depends on USB, but would "require USB".
> If the decide to include the webcam she will optionally be prompted
> so she can decide if it is OK to include USB support too

This would be a nice feature. In fact, some SELECT's were wrongly added 
in the past, at V4L/DVB Kconfig's as people understood that this would be 
the behaviour of SELECT.

IMO, I think it is preferred that "SELECT" could act as you've described: 
Check if all dependencies for the selected symbol are satisfied. If not, 
auto-selects or prompt to the users.

The auto-select feature, without prompting could be very helpful to allow 
testing kconfig items, since, instead of running all randomconfig's, 
subsystem maintainers can use scripts that will do something like 
allnoconfig, and then select just the symbols requested by each driver 
(*).


(*) Something like:
 	make select="DRIVER_FOO"
 		and
 	make select="DRIVER_FOO_MODULE"

could just do this: marks NO to everything and Y (or M) to the symbol, and 
just the required dependencies for that symbol to compile.

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
