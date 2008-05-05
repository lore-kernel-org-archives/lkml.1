Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbYEERHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbYEERHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbYEERHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:07:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219AbYEERHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:07:31 -0400
Date: Mon, 5 May 2008 10:07:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: changeset: Make forced module loading optional
In-Reply-To: <200805051535.05370.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.10.0805050957590.32269@woody.linux-foundation.org>
References: <200805051455.02723.rusty@rustcorp.com.au> <alpine.LFD.1.10.0805042159230.32269@woody.linux-foundation.org> <200805051535.05370.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 May 2008, Rusty Russell wrote:
> 
> BTW, for the peanut gallery: I don't recommend modversions: it's not reliable
> in detecting all differences, nor being stable when there are no real
> differences.

Umm. modversions is in general a whole lot *more* reliable than just 
looking at the kernel version.

The kernel version is pretty good if you use CONFIG_LOCALVERSION_AUTO and 
have a git kernel tree, but if not, then modversions is much more likely 
to stop modules across big infrastructure changes during (say) the merge 
window.

So I agree that modversions is not "reliable", but I think that the 
alternative is often even *less* reliable, so I find the "don't recommend 
modversions" comment to be pretty debatable.

Since I personally try to avoid modules, and if I do use them I'd prefer 
the checking to be as strict as possible, I'd really not mind a "strict"  
mode that tests both MODVERSIONS _and_ the full kernel version string. 
Along with not allowing forced module loads, of course.

I also find it sad that apparently I'm one of the few ones that test with 
modules turned off. It's both more secure and simpler, but it does cause 
lots of noise at least during a Fedora boot, and it occasionally breaks 
the /etc/rc.d scripts because they assume that they have to load modules, 
and that it's an error if that fails. We had that happen with the iptables 
scripts not that long ago (and note how that was unrelated to initrd: this 
is past the point when things have switched to the normal root 
filesystem).

IOW, I wish distros did some testing with non-modular kernels too. Oh 
well. At least I can generally fix the problems, and make error reports, 
but I bet it means that most other kernel users simply turn on modules 
whether they need them or not.

			Linus
