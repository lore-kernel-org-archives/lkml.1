Return-Path: <linux-kernel-owner+w=401wt.eu-S1763934AbYGOVRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763934AbYGOVRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbYGOVOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:14:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39490 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbYGOVOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:14:33 -0400
Message-ID: <487D1327.7090805@garzik.org>
Date: Tue, 15 Jul 2008 17:14:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org> <487C585C.2060002@garzik.org> <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org> <487CD7FE.9010209@garzik.org> <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org> <487CDEC0.3090004@garzik.org> <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org> <487CEA73.9000408@garzik.org> <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org> <487CF01E.6000208@garzik.org> <20080715185801.GH8185@mit.edu> <487CF70C.1030309@garzik.org> <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151218460.3351@woody.linux-foundation.org>
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
>> Already started, in fact, since Linus said he would not reject it out of
>> hands.
> 
> Btw, I need to see it actually solve a real problem. As it is, I really 
> think you've just painted yourself into a corner where you can't just 
> admit that we can just load the firmware directly.

Kernel 2.6.26.  Older userland w/ initrd requirement, plus module w/ 
compiled-in firmware.

Simply dropping 2.6.27 into that situation will produce an unbootable 
system, since the firmware would not get copied into the initrd.

That's not just a kernel hacker situation.  Plenty of sites, even a few 
large Red Hat deployments, run newer kernels on a known-stable, older 
userland.  RH does not actively support swap-in-your-own-kernel, 
preferring our own tested kernel, but new-kernel/older-userland is not 
uncommon.

With upstream as it is today, there are just too many little ways the 
firmware can fail to follow the driver it once lived inside.  And the 
consequences of failure are delayed (until next boot), silent (until 
next boot), and notable (may produce non-booting system, certainly a 
non-working driver).

	Jeff



