Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYKBUdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYKBUdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 15:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYKBUdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 15:33:09 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:52171 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbYKBUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 15:33:09 -0500
Date: Sun, 2 Nov 2008 21:31:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] el3_common_init() should be __devinit, not __init
Message-ID: <20081102203156.GC4330@uranus.ravnborg.org>
References: <E1KwL59-0000Ug-F1@ZenIV.linux.org.uk> <20081101191250.GA7588@x200.localdomain> <20081101191614.GA28946@ZenIV.linux.org.uk> <20081101192757.GA7622@x200.localdomain> <20081101211724.GA16941@uranus.ravnborg.org> <alpine.LFD.2.00.0811021008060.3483@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811021008060.3483@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2008 at 10:13:03AM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 1 Nov 2008, Sam Ravnborg wrote:
> > 
> > For cpuinit/cpuexit the gain turned out to be minimal.
> 
> Quite frankly, I'm not convinced.
> 
> Yeah, yeah, most distro's end up always enabling CPU hotplug due to 
> suspend/resume, but:
> 
>  - desktop PC's aren't where most memory pressures are anyway
> 
>  - on UP, CONFIG_HOTPLUG_CPU isn't on even if you do have suspend/resume
> 
>  - we should still care about embedded devices, and while some of them are 
>    growing up (and having SMP and not caring about a few tens of kB of 
>    memory), I don't think that's a valid argument for the other ones.

I benchmarked by investigating a common arm config and not some bloated
x86 desktop config when analysing the cpuinit/cpuexit case.

Another reason why I like to see cpuinit dropped is that it is misused
all over. __cpuinit are used for two purposes:
- to annotate code/data that is only used in the early init phase if
  HOTPLUG_CPU is not enabled
- to annotate code/data that is only used if HOTPLUG_CPU is enabled

The latter use is plain wrong but I never managed to really get to
the bottom of it.

If we could use our config ssytem in the normals ways to cover
with code that is only used for HOTPLUG_CPU then things would be
much simpler.

When I have done sweep fixing all section mismatchs it has almost
always been cpuinit that has caused me most troubles.
The others has been trivial to deal with.

As Al points out in his reply a full day effort can fix a lot
of the remaining ones.

For devinit/devexit there is in my mind no questions that they
shall remain.

The most important topic to address is to get better detection.
What we can do in modpost is limited :-(

	Sam
