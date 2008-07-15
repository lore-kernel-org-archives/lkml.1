Return-Path: <linux-kernel-owner+w=401wt.eu-S1761729AbYGOTj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729AbYGOTj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbYGOTjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:39:21 -0400
Received: from senator.holtmann.net ([87.106.208.187]:45396 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbYGOTjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:39:21 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Frans Pop <elendil@planet.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, jeff@garzik.org,
       arjan@infradead.org, akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20080715180535.GA6080@khazad-dum.debian.net>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
	 <20080715180535.GA6080@khazad-dum.debian.net>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 21:39:29 +0200
Message-Id: <1216150769.27242.81.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrique,

> > You release 2.6.27-rc2 and I build it. Ouch! It fails to install, at least 
> > if I want to install it _alongside_ 2.6.27-rc1 or other kernels (which I 
> > do!). Why does it fail? Because dpkg's package management does not allow 
> > one package to overwrite files already "owned" by another package.
> 
> I believe I read in the previous thread that some distros are already using
> /lib/firmware/<kernel version>/.
> 
> There was also the suggestion of moving the entire set of kernel-packaged
> firmware to /lib/modules/<kernel version>/firmware, probably while keeping
> /lib/firmware as a second place to look for firmware so that we don't hose
> any system.

can we please leave the /lib/modules/*/firmware idea out of it. While
this thread is about the kernel drivers that need firmware loading, but
it is not the whole story. We do have hardware that needs a firmware
loading process that takes place entirely in userspace. In some USB and
UART cases we can do the firmware loading step before any kernel driver
takes control of that device and currently these firmware loading
helpers look into /lib/firmware/ where every firmware file should be
placed.

Also the /lib/firmware directory was chosen a long time ago and you find
the discussion on the linux-hotplug mailing list archive if you are
interested.

That said, using /lib/firmware/`uname -r`/ like Ubuntu supports right
now and then fall back to /lib/firmware looks like a sane approach to
me. However as David mentioned, this needs patches to udev first before
we go any step further.

Regards

Marcel


