Return-Path: <linux-kernel-owner+w=401wt.eu-S1762333AbYGOSF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333AbYGOSF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762205AbYGOSFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:05:42 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46336 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762180AbYGOSFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:05:41 -0400
X-Sasl-enc: /IhEXhVz3zkIzUoGsrH2T8GbEKVNLYS+7hf3yzQEZrwL 1216145140
Date: Tue, 15 Jul 2008 15:05:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Frans Pop <elendil@planet.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jeff@garzik.org,
       arjan@infradead.org, akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
Message-ID: <20080715180535.GA6080@khazad-dum.debian.net>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <200807151757.10626.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807151757.10626.elendil@planet.nl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Frans Pop wrote:
> So then I build 2.6.27-rc1 and install it. Great.
> 
> You release 2.6.27-rc2 and I build it. Ouch! It fails to install, at least 
> if I want to install it _alongside_ 2.6.27-rc1 or other kernels (which I 
> do!). Why does it fail? Because dpkg's package management does not allow 
> one package to overwrite files already "owned" by another package.

I believe I read in the previous thread that some distros are already using
/lib/firmware/<kernel version>/.

There was also the suggestion of moving the entire set of kernel-packaged
firmware to /lib/modules/<kernel version>/firmware, probably while keeping
/lib/firmware as a second place to look for firmware so that we don't hose
any system.

> If I were able to compile firmware into the modules, the problem would be 
> solved in one go.

And this thread would have been shorter, even. I hope someone decides to
write that support instead of complaining ;-)

But I do feel we still need a smarter userspace firmware loader to make
firmware packaging less insane.  The "current aproach" you described, with
one firmware per package, is not good.  It doesn't allow for multiple
versions of the firmware to be installed should you need it.

> I don't know how the Debian kernel team plans to deal with this for distro 
> kernel packages. They probably _do_ want to keep them separate [2]. Maybe 
> by grouping firmware for really common drivers into 
> firmware-basic-drivers or something along those lines.

I sure hope we go with the more proper fix (a version-enabled firmware
loader that can do the unversioned /lib/firmware as well).  It is far more
resilient in the long run.

> [1] Only quick solution I see is to have it install the firmware in a 
> versioned directory and have the postinst copy things from there to
> /lib/firmware.

Yuck.  That would work only if you never needed two active copies of the
kernel [with different firmware files] active at the same time.

> [2] As one of the developers for Debian Installer I'm not looking forward 
> to the complications that is going to cause for us and users.

That was my point.  These firmware loading changes are good, but there is a
lot of crap missing (most of it NOT in the kernel) before it can be exposed
to ordinary users.

And without firmware-in-the-module support (which is the ONLY scenario where
the entire userspace will not notice anything different), this WILL cause
problem to distros, we will need to scramble up and fix it all before we can
package 2.6.26.  I don't know if this is a big problem, though.  The work
will need to be done sooner or later anyway, and we should have enough time
to do so as long as we don't care for packaging the early -rc.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
