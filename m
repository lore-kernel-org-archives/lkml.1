Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbZFKRWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbZFKRWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZFKRWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:22:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:7459 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZFKRWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=tzFARPfdhPP8nAYPSO5ULqL3cgYp2nj3NsTz1Bo7gw9BW+50i1hwFRX1gq4UOFZOLO
         /tZ8WG+W8AD5ZHZFnSX4CB4s7wxkUetZRR4PiRAEWccW1GoYVixO3v2QenUKqBygJAxs
         VOoHe9bv4E6/cpF5SPjtypkmD4jK2b1QVIbBQ=
MIME-Version: 1.0
In-Reply-To: <20090611171259.GW8633@ZenIV.linux.org.uk>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> 
	<alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> 
	<20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> 
	<20090611170015.GA3651@infradead.org> <2c0942db0906111005g5e9cd1c7te603bcdb8c6cc921@mail.gmail.com> 
	<20090611171259.GW8633@ZenIV.linux.org.uk>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Thu, 11 Jun 2009 10:22:23 -0700
X-Google-Sender-Auth: 5c3c1cf23ac93af0
Message-ID: <2c0942db0906111022s442be8fbl47656a60e2619b9d@mail.gmail.com>
Subject: Re: [GIT PULL] Performance Counters for Linux
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:12 AM, Al Viro<viro@zeniv.linux.org.uk> wrote:
> On Thu, Jun 11, 2009 at 10:05:02AM -0700, Ray Lee wrote:
>> Packagers are quite used to taking a single source tree and building
>> multiple packages out of it. This isn't rocket science. It's the
>> multiple separate trees that need to be released in lock-step that are
>> headaches.
>
> Wrong.  Remember the fun bisecting around sysfs/udev incompatible change?
> Oops, went back past the cutoff line, got to downgrade udev for the next
> boot.  Oh, it oopses?  Too fucking bad, can't just boot the previous kernel,
> should've kept _two_ working ones so that with any userland state we could
> come back to working system.
>
> This isn't a rocket science, this is a goddamn load of horse manure.
> Packages that need to be updated in the lock-step *are* headaches from
> hell when you are trying to do development.  Even if you have all of
> them already built.

Well, welcome to our new world order of Xorg and udev and hal. I have
had to deal with bisecting the problem just as you have, and dealt
with the fallout.

The choices are:

 - Don't bisect, throw up your hands and hope someone else deals with it

 - keep the old versions around for installs, as you point out (I do
this regularly)

 - build all the packages every time

The last one is the most reasonable and I'd argue it's the right thing
to do. But it's tricky with multiple source trees -- which version of
udev works with this kernel again? A single source tree for packages
that are kept in lock-step, as so many seem to be, makes that a hell
of a lot easier on me.

But perhaps I'm an odd-ball.

I think your complaint is "Why the hell can't they have a stable ABI?"
Probably for the same reason anything so close to the hardware hasn't
had a stable ABI. I'm sure udev/hal/Xorg will have a stable
kernel-userland interface any day now. Once they do, I'm sure
everything else that touches the hardware so intimately will have a
stable ABI too.

Sheesh.
