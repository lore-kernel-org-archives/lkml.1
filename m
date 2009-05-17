Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZEQCIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZEQCIr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 22:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZEQCIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 22:08:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917AbZEQCIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 22:08:35 -0400
Date: Sat, 16 May 2009 19:06:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?UTF-8?Q?Ozan_=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.30-rc6: Reported regressions from 2.6.29
In-Reply-To: <4A0F5B2A.8010009@pardus.org.tr>
Message-ID: <alpine.LFD.2.01.0905161859170.3301@localhost.localdomain>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <alpine.LFD.2.01.0905161644350.3301@localhost.localdomain> <4A0F5B2A.8010009@pardus.org.tr>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 May 2009, Ozan Çağlayan wrote:
> 
> The patch[0] from Andrew fixed the problem.

Yeah, but that's the patch that I think isn't the long-term solution (ie 
other drievrs will do things like this too).

Also, I'm not 100% convinced it's even the right one for cmos-rtc, 
although I can't really judge. The thing is, even if the 
pnp_register_driver() call fails, I'm not at all sure that we shouldn't 
just continue. I suspect we might still want to do the 
platform_driver_probe regardless of any PnP issues.

I dunno. What I _do_ know is that I'd be happier of 

	pnp_register_driver(&driver);
	pnp_unregister_driver(&driver);

always worked without oopsing, regardless of whether the registration 
worked or not. Whether the rtc-cmos driver shold do that is then a 
secondary issue. 

The whole PnP thing has been broken several times, look for example at 
commit 72f22b1eb6ca5e4676a632a04d40d46cb61d4562. That one introduced the 
whole "do the platform driver regardless of any PnP driver issues", which 
makes me suspect we really shouldn't return early just because of some 
random pnp issue.

			Linus
