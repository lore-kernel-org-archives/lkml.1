Return-Path: <linux-kernel-owner+w=401wt.eu-S966614AbZLHWAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966614AbZLHWAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966512AbZLHWAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:00:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49674 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966618AbZLHWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:00:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Airlie <airlied@redhat.com>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Tue, 8 Dec 2009 22:59:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
References: <200912071830.14697.arnd@arndb.de>
In-Reply-To: <200912071830.14697.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912082259.48715.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Jmpi03oppRsclMPN/gZ0fa6axmXZYdtexYNH
 uxiNxhr2a2ctLv8V+GFRhz1MhP/w7+QyfWb/+naCjVSRhsr+1o
 v4yqwI6flKjPZXVgS/XkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009, Arnd Bergmann wrote:
> After upgrading one of my machines to 2.6.32, I saw hangs after one to thirty minutes after
> booting, with random data written to parts of the frame buffer. I've bisected it down
> to 620f37811d "drm: prune modes when output is disconnected.", which was merged
> in 2.6.32-rc1. Connecting a serial console does not reveal any output at the time of
> the crash.
> 
> The machine uses an Intel G45 chipset with the i915 kernel mode setting enabled.
> 
> I have no clue what that patch does or why reverting it fixes the problem but 2.6.32
> with this revert applied has not shown these hangs yet.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Scratch this, the machine crashed again in the same way, but only after
a some hours of uptime (normally it took a few minutes). It still looks like
 this commit makes the bug much more likely, but it could also be
attributed to complete coincedence and bad timing. 2.6.31 certainly never
showed the problem and the bisection clearly pointed in the general direction
of i915.

I hate debugging sporadic hangs...

Sorry for blaming the wrong patch, especially if it already caused a lot 
of work. I'll try blaming ec2a4c3fdc8 "drm/i915: get the bridge device
once" now, that is the next-best candidate that my bisection pointed to,
but I'll do more rigorous testing.

	Arnd
