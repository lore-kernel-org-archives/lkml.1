Return-Path: <linux-kernel-owner+w=401wt.eu-S1751570AbZHZEV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbZHZEV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 00:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbZHZEV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 00:21:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbZHZEVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 00:21:25 -0400
Date: Tue, 25 Aug 2009 21:20:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Zhenyu Wang <zhenyuw@linux.intel.com>
cc: Eric Anholt <eric@anholt.net>, mailing54 <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       Ma Ling <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>, Keith Packard <keithp@keithp.com>
Subject: Re: Linux 2.6.31-rc7
In-Reply-To: <20090826035840.GA16894@zhen-devel.sh.intel.com>
Message-ID: <alpine.LFD.2.01.0908252114130.3218@localhost.localdomain>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain> <4A941E8B.8080902@plzk.org> <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain> <4A94599F.9020508@plzk.org> <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
 <1251239637.26348.20.camel@gaiman.anholt.net> <20090826015127.GA1402@zhen-devel.sh.intel.com> <alpine.LFD.2.01.0908252027300.3218@localhost.localdomain> <20090826035840.GA16894@zhen-devel.sh.intel.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Aug 2009, Zhenyu Wang wrote:
> 
> We can't depend on any BIOS display config as you noted before our driver.

But you do. You depend on the even _less_ reliable existence of a VBT 
table.

> And our driver does more flexible config than VBIOS does.

If by "flexible" you mean "doesn't work in many more ways", then yes.

I have never EVER found a BIOS that didn't output to at least _some_ 
screen that is connected. That's fairly damn fundamental. Yet that is 
exactly what KMS screws up on some hardware right now.

Trust me, "flexible" is not the right word. 

> We know we have problem on Mac mini, this issue has been known for a while.
> And Keith also posted patch at
> 	http://lists.freedesktop.org/archives/intel-gfx/2009-June/002843.html
> but I don't know the status of this now.

And how about MacBook 2.1, which apparently also goes black?

And the Westmere thing? 

> We've tried many ways to detect LVDS, but none is stable or actually work for
> every chip. But now we have DMI quirks for some known no LVDS machine (including
> Mac mini), and we detect through ACPI LID object for LVDS exist. 

And dammit, if you cannot detect it, then don't try.

You'd actually be better off not trying your random crud, and instead
 - leave whatever connection the BIOS set up
 - let the user _tell_ you about other ones.

If you cannot reliably detect something, don't go off and use some random 
number generator. And quite frankly, depending on BIOS tables _is_ a 
random number generator. It may be that you just haven't learnt that yet, 
but maybe you could work on ACPI for a while to see what I mean.

Right now, there's not even any way to _override_ your incorrect guesses. 

So I can say "don't do mode-setting at all", but I can't say "use SVDO at 
1680x1050". So my screen goes black. And I happen to be in the enviable 
position of having known about the Mac Mini issues and the KMS thing - 
think about what happens to people that just try a new distro kernel, and 
suddenly there's nothing on the screen. 

			Linus
