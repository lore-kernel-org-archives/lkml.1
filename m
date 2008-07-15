Return-Path: <linux-kernel-owner+w=401wt.eu-S1761648AbYGOTb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761648AbYGOTb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbYGOTbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:31:20 -0400
Received: from senator.holtmann.net ([87.106.208.187]:49772 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbYGOTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:31:20 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
	 <1216149637.27242.65.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 21:31:28 +0200
Message-Id: <1216150288.27242.75.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > using /lib/firmware/`uname -r`/ is actually not a bad idea. You only
> > have to fix udev to actually include this in the list of directories to
> > look for firmware files. Also Ubuntu is already doing this.
> 
> I really don't think we need to even "fix udev".

fixing udev means adding an extra path to it :)

> Why don't we just load it ourselves? Esepcially as there are probably 
> places that try to avoid udev entirely, or at least use a very 
> cut-down-version.
> 
> We should be fairly trivially able to be _entirely_ backwards compatible 
> with any sane setup (not the _sane_ part! It implies that people don't 
> copy individual modules around by hand!), with no actual breakage or need 
> for distros to even update anything at all - just make the kernel able to 
> look up binary blobs in the same place it installed them.
> 
> That sounds like the RightThing(tm) to do _regardless_ of any other 
> issues, doesn't it? If the kernel installs it in some known place, why 
> should it not just read them from that known place?

Personally I am against hacking file loading from within the kernel.
This is why we involved udev (or hotplug in the beginning). It allows
you to have userspace policy for the search paths etc.

Regards

Marcel


