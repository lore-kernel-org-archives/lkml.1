Return-Path: <linux-kernel-owner+w=401wt.eu-S966722AbZLHWPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966722AbZLHWPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966578AbZLHWPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:15:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966711AbZLHWPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:15:19 -0500
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes
 when ..."
From: Dave Airlie <airlied@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
In-Reply-To: <200912082259.48715.arnd@arndb.de>
References: <200912071830.14697.arnd@arndb.de>
	 <200912082259.48715.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 08:13:52 +1000
Message-Id: <1260310432.12969.0.camel@t60prh>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 22:59 +0100, Arnd Bergmann wrote:
> On Monday 07 December 2009, Arnd Bergmann wrote:
> > After upgrading one of my machines to 2.6.32, I saw hangs after one to thirty minutes after
> > booting, with random data written to parts of the frame buffer. I've bisected it down
> > to 620f37811d "drm: prune modes when output is disconnected.", which was merged
> > in 2.6.32-rc1. Connecting a serial console does not reveal any output at the time of
> > the crash.
> > 
> > The machine uses an Intel G45 chipset with the i915 kernel mode setting enabled.
> > 
> > I have no clue what that patch does or why reverting it fixes the problem but 2.6.32
> > with this revert applied has not shown these hangs yet.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Scratch this, the machine crashed again in the same way, but only after
> a some hours of uptime (normally it took a few minutes). It still looks like
>  this commit makes the bug much more likely, but it could also be
> attributed to complete coincedence and bad timing. 2.6.31 certainly never
> showed the problem and the bisection clearly pointed in the general direction
> of i915.
> 
> I hate debugging sporadic hangs...
> 
> Sorry for blaming the wrong patch, especially if it already caused a lot 
> of work. I'll try blaming ec2a4c3fdc8 "drm/i915: get the bridge device
> once" now, that is the next-best candidate that my bisection pointed to,
> but I'll do more rigorous testing.
> 

Btw is this just a laptop with no monitor plugged in?

just want to rule out the patch you mentioned for any sort of memory
corruption.

Dave.


