Return-Path: <linux-kernel-owner+w=401wt.eu-S1762585AbYGOSVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762585AbYGOSVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbYGOSVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:21:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60203 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbYGOSVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:21:07 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Frans Pop <elendil@planet.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, jeff@garzik.org,
       arjan@infradead.org, akpm@linux-foundation.org,
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
Date: Tue, 15 Jul 2008 11:20:57 -0700
Message-Id: <1216146057.27455.325.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 15:05 -0300, Henrique de Moraes Holschuh wrote:
> 
> I believe I read in the previous thread that some distros are already using
> /lib/firmware/<kernel version>/.
> 
> There was also the suggestion of moving the entire set of kernel-packaged
> firmware to /lib/modules/<kernel version>/firmware, probably while keeping
> /lib/firmware as a second place to look for firmware so that we don't hose
> any system.

You can do that right now; I expect Ubuntu will, since their userspace
already looks like that. You just need to set $(INSTALL_FW_PATH) when
you install the firmware (or modules).

The Ubuntu folks have chosen not to share their changes with upstream,
though -- and if we were to _impose_ that policy, then we would be
requiring changes to userspace which are not yet widespread. That's a
bad idea. What we're doing right now is _entirely_ compatible with what
userspace already has to deal with for modern drivers, and that's very
important.

There may be some merit in Ubuntu's policy, but we need userspace to
change first, long before we can change the default in the kernel.

But certainly the kernel _allows_ that, if you want it.

-- 
dwmw2

