Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbYGOUVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbYGOUVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYGOUVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:21:05 -0400
Received: from senator.holtmann.net ([87.106.208.187]:44608 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYGOUVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:21:04 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
	 <1216149637.27242.65.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
	 <1216150616.27455.377.camel@shinybook.infradead.org>
	 <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
	 <1216151640.27242.90.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 22:21:10 +0200
Message-Id: <1216153270.27242.110.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > you don't have to. We extend udev once and then it will always work.
> 
> Umm. The thing is, people running new kernels with old user land is not 
> just supposed to work, it's _really_ supposed to work.
> 
> It's what I do. Something that breaks that has to have damn good reasons 
> to break it.

so request_firmware() is well established and works. It is used by a
bunch of drivers at the moment.

If we do wanna make more heavy use of it (which seems everybody is in
agreement) then we need to make some userspace changes like adding the
kernel version to keep it sane. This can be done step by step to make
sure we keep the current status quo.

And as David mentioned multiple times, he left drivers/{net,scsi} out of
it for now.

> So I do not disagree with Jeff on that point _at_all_. I'm in violent 
> agreement with Jeff on the fact that we should not require system updates 
> for the kernel to do the right thing.
> 
> The thing I disagree with Jeff on is that he then seems to turn that into 
> something very negative ("let's not separate the firmware at all").
> 
> And I'd much rather just fix it. And that means that if people can point 
> to udevd's that get confused - or lack of udevd's entirely - both of which 
> sound very likely to me, then we should have a graceful fallback position.
> 
> And just supporting the notion of loading the firmware directly sounds 
> like an obvious such case. It may not be the _only_ solution, for example, 
> which is why I'd actually like to see people point to the _actual_ 
> reported problems.

I really don't see that problem here since request_firmware() has been
around for so long now and so many drivers are using it nowadays that I
don't see your point here on how it will break.

However if you wanna make the kernel do the loading from the filesystem
directly, I am actually fine with it. We were opposed to that idea,
because it was always kinda hackish to have the kernel load files and it
felt wrong to do it this way. Policy decisions on directory layouts
belong into the userspace and not the kernel. At least that is my take
on this.

Regards

Marcel


