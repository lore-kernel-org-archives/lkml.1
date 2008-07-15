Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbYGOU4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbYGOU4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYGOUzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:55:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56073 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbYGOUzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:55:54 -0400
Message-ID: <487D0ED1.7010003@garzik.org>
Date: Tue, 15 Jul 2008 16:55:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Frans Pop <elendil@planet.nl>, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org> <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <200807151757.10626.elendil@planet.nl> <20080715180535.GA6080@khazad-dum.debian.net> <487CE917.3000000@garzik.org> <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org> <487CF29E.5000009@garzik.org> <alpine.LFD.1.10.0807151159400.3351@woody.linux-foundation.org> <487D01B5.7020300@garzik.org> <alpine.LFD.1.10.0807151310370.2867@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151310370.2867@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 15 Jul 2008, Jeff Garzik wrote:
>> Already posted a list.
> 
> No you didn't.
> 
> You posted a list of problems you have from doing odd and stupid things. 
> Not the reports, not the explanations of what those odd and stupid 
> things actually were in practice, and why they had to be that stupid.
> 
> Quite frankly, I suspect that it's all a matter of "people compiled their 
> own kernels, and didn't copy the new files, because they just didn't 
> realize they needed to".

No, I spelled out a list of projects, what would break, and how it would 
break.

Again,

* Red Hat driver disks.  The build process is unaware of the need to 
bundle firmware.  Any use with Fedora (or, later, RHEL) will result in a 
non-working driver, for the simple reason that firmware is not copied 
onto the image.

* Embedded projects like OpenWRT, that divide up kernel modules into 
multiple packages.  Since it's not just one big package, you have to 
update each package's list of files to include the newly split-out 
firmwares.  Failure to do so results in a successful build set of 
packages... of drivers that lack their firmware.

* Router and embedded system image builders like tomsrtbt, with similar 
problem to RH driver disks:  they simply do not know that a firmware 
needs to be copied into the image, alongside the tg3 driver.

* Older userlands where, axiomatically, the mkinitrd and other firmware 
fixes have not been made, and may never be made.

Yes, it is a matter of education.

Yes, it is a matter of fixes.

That does not change the fact that 2.6.27 will mean non-working drivers 
for these situations, and there is a simple remedy for this entire class 
of problems:  retain ability to compile firmware into the module.

That does not change the fact that useful testers may be turned away 
from 2.6.2[78] while waiting for Red Hat or OpenWRT or whomever to fix 
their stuff.

	Jeff


