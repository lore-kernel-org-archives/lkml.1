Return-Path: <linux-kernel-owner+w=401wt.eu-S1761188AbYFDSER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188AbYFDSER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYFDSEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:04:06 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41042
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbYFDSEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:04:05 -0400
X-Greylist: delayed 687 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2008 14:04:03 EDT
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Adrian Bunk <adrian.bunk@movial.fi>
Subject: Re: [PATCH] console - Add configurable support for console charset translation
Date: Wed, 4 Jun 2008 12:51:42 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <48447615.5050806@am.sony.com> <20080604103353.GC27335@cs181133002.pp.htv.fi>
In-Reply-To: <20080604103353.GC27335@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806041251.43432.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 June 2008 05:33:53 Adrian Bunk wrote:
> Does the linux-tiny approach of adding a kconfig variable for each 5kB
> of code actually make sense? I'm asking since an exploding amount of
> kconfig variables and their interdependencies have a not so small
> maintainance impact in the long term.

Complexity is a cost, you have to get good bang for the buck when you spend 
it.

> And I'm wondering whether it's the best approach for reaching
> measurable results.

When I first started stripping down systems to make embedded masquerading 
routers back in the late 90's (before linksys came out), I started with a Red 
Hat install and removed lots and lots of packages.  That's the approach we're 
taking today, and I can say from experience that it's not sustainable.

I then wandered to a Linux From Scratch approach, building a system that had 
nothing in it but what I wanted.  Starting from zero and adding stuff, rather 
than starting from Mt. Crapmore and removing things until the shovel broke.

Someday I want to do the same for the Linux kernel.  When I started building 
systems instead of carving them out of blocks of distro, I started with 
a "hello world" root filesystem, and I want to make a "hello world" kernel.  
Start with just the boot code that does the jump to C code, only instead of 
start_kernel() in init/main.c have it call a hello_world() function that 
prints "hello world" to the console using the early_printk logic, then calls 
HLT.  And does _nothing_else_.  Then add stuff back one chunk at a time, 
sstarting with memory management, then the scheduler and process stuff, then 
the vfs, and so on.  So I know what all the bits do, and how big and 
complicated they are.  And I can document the lot of it as I go.

Unfortunately, as a learning experience, I estimate this would take me about a 
year.  And I haven't got a spare year on me at the moment.  But it remains 
prominently on my todo list, if I decide to start another major project.  
(Maybe after I get a 1.0 release of FWL out.)

> My gut feeling is that the influence of this kind of linux-tiny patches
> is hardly noticably compared to the overall code size development, but
> if you have numbers that prove me wrong just point me to them and I'll
> stand corrected.

The whackamole approach is never going to turn Ubuntu into Damn Small Linux, 
and it ignores the needs of the people who don't want the /proc hairball but 
_do_ want a ps that works.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
