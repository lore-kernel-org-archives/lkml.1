Return-Path: <linux-kernel-owner+w=401wt.eu-S1761519AbYILVCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519AbYILVCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761216AbYILVAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:00:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48129 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761207AbYILVAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:00:14 -0400
Message-ID: <48CAD838.3050907@garzik.org>
Date: Fri, 12 Sep 2008 16:59:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, david@lang.hm,
       Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, arjan@infradead.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org> <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm> <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org> <200807160222.40705.elendil@planet.nl> <alpine.LFD.1.10.0807151726520.2867@woody.linux-foundation.org> <487D441B.5010908@garzik.org> <20080716044228.GN1369@1wt.eu>
In-Reply-To: <20080716044228.GN1369@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> Exactly. To give you an idea, I have a lot of servers running on a
> "firmware" which consists in two parts :
>   - a bzImage containing an initramfs with modules and a few scripts
>   - an initrd which is in fact the rootfs
> 
> When the kernel boots, it mounts the initrd, does a pivot_root and mounts
> its modules into /boot/$(uname -r). All my kernels run modules from /boot
> and not from /lib/modules, because it makes them more convenient to add
> and remove. So /lib/modules is just a symlink to /boot.
> 
> The above process is very convenient, as it is compatible with a lot of
> boot methods : hard disk, CDROM, USB stick, PXE, etc...
> 
> And moreover, I can have multiple kernels with only one rootfs (SMP, etc).
> Introducing firmware there would mean a major thinking and rework of the
> build (and possibly boot) process. The least invasive would probably be
> to stuff them next to the modules in $(uname -r)/firmware, but even then,
> it will take a lot of time to switch to a new system.
> 
> And judging from what I see around, I'm far from being the only one not
> using mkinitrd.


FWIW, due to both lack of time and lack of (apparent) interest, I didn't 
bother moving forward with the compile-firmware-into-module, even though 
I still think it would be useful to add [back].

	Jeff


