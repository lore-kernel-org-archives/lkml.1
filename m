Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXJWFPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXJWFPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXJWFO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:14:57 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:39130 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752062AbXJWFOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:14:55 -0400
Message-ID: <471D834B.1080501@crispincowan.com>
Date: Mon, 22 Oct 2007 22:14:51 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Thomas Fricaccia <thomas_fricacci@yahoo.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LSM ML <linux-security-module@vger.kernel.org>
Subject: Re: LSM conversion to static interface
References: <200710221700.l9MH0klg006152@sapphire.spiritone.com> <20071022171326.GA30317@kroah.com>
In-Reply-To: <20071022171326.GA30317@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Oct 22, 2007 at 10:00:46AM -0700, Thomas Fricaccia wrote:
>   
>> Security is big business, as is compliance with regulatory law.  Large
>> enterprise customers are NOT going to either void their system support
>> contracts, or place themselves in jeopardy of failing a SOX audit.
>>     
> I agree, that is why customers do not load other random security modules
> in their kernel today,
That "random" module could be a module supplied by a vendor other than
the distro supplier, such as a security vendor. It could be a research
prototype that the user wants to try out on their enterprise-supported
kernel. It could even be an in-house developed module that a local site
wants to run on his larger organization's blessed kernel.

So far from "random", these modules are motivated by circumstances
radically different than yours. In particular, rebuilding a kernel for
you (GregKH, many LKML developers) is a casual thing to be done before
breakfast, but is a scary obstacle to many others. It is an obstacle to
people who are skilled at computers but deliberately *not* kernel
developers (the whole world does not need to be a Linux kernel
developer) and it is an obstacle to large enterprise admins who have
organizational pressure to use specific, pre-built kernels.

>  and why they will not do so tomorrow.  So,
> because of that, this whole point about compliance with regulatory law
> seems kind of moot :)
>   
I think the specific stuff about regulatory compliance is tangential.
SarBox and friends don't specify Linux kernel versions, they are
incredibly vague and subject to interpretation. But they are part of
what drive organizations to have self-imposed rules about only running
blessed kernel versions.

Suffice it to say that there are a variety of reasons why someone either
cannot re-compile a kernel, or just does not want to recompile a kernel.
This change to LSM removes their choice to use modules others than those
provided by their distro vendor.

> Again, LSM isn't going away at all, this is just one config option for
> allowing LSM to work as a module that is changing.  If a customer
> demands that this feature come back, I'm sure that the big distros will
> be the first to push for it.  But currently, given that there are no
> known external LSMs being used by customers demanding support, I don't
> see what the big issue here really is.
>   
As I said, it is a medium issue, not a big one, which is why I didn't
speak out before.

I am opposed to this change because I see zero benefit to it, and a lot
of down-side in loss of user choice.

Because that is what this does: it does not help the kernel get better.
It *definitely* does not help the kernel become more secure. It mostly
just removes user's choice, by making it difficult to do things that
some people don't approve of.

As I've said, it doesn't hurt AppArmor, because 3 major distros ship it.
But it will hurt user choice and innovation, by making anything not
shipped by a distro more difficult to access.

There is some performance gains to be had by doing something to the LSM
interface. Certainly a configuration option that statically inlines all
the hooks and points them at a compiled in module would yield some
performance gain, but I don't know how much. But that raises 2 questions:

   1. Was *performance* really the reason this patch was proposed? Or
      was it because James really did want the restrictive effect of
      preventing people from choosing after-market modules and
      dynamically unloading them if they want? I believe that James was
      well-intentioned in trying to block these actions because he
      believes them to be insecure, and he's right, they are insecure.
      However, these actions are also very practically useful in many
      circumstances. I disagree with the change because an individual
      LSM can block both such actions if you wish, so imposing it on all
      LSM modules is restricting choice unnecessarily.
   2. Is the performance issue that this might address really big enough
      to bother fixing at all? Maybe, but I don't know. Again, I'm
      strictly opposed to the loss of flexibility until the performance
      issue is documented, and then I would rather see it be a
      configuration option you can choose to inline your module of
      choice, rather than the default behavior.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
	       Itanium. Vista. GPLv3. Complexity at work

