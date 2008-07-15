Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbYGOT15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbYGOT15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbYGOT1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:27:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756484AbYGOT1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:27:49 -0400
Date: Tue, 15 Jul 2008 12:27:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marcel Holtmann <marcel@holtmann.org>
cc: Frans Pop <elendil@planet.nl>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <1216149637.27242.65.camel@violet.holtmann.net>
Message-ID: <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
  <200807151757.10626.elendil@planet.nl> <1216149637.27242.65.camel@violet.holtmann.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Marcel Holtmann wrote:
> 
> using /lib/firmware/`uname -r`/ is actually not a bad idea. You only
> have to fix udev to actually include this in the list of directories to
> look for firmware files. Also Ubuntu is already doing this.

I really don't think we need to even "fix udev".

Why don't we just load it ourselves? Esepcially as there are probably 
places that try to avoid udev entirely, or at least use a very 
cut-down-version.

We should be fairly trivially able to be _entirely_ backwards compatible 
with any sane setup (not the _sane_ part! It implies that people don't 
copy individual modules around by hand!), with no actual breakage or need 
for distros to even update anything at all - just make the kernel able to 
look up binary blobs in the same place it installed them.

That sounds like the RightThing(tm) to do _regardless_ of any other 
issues, doesn't it? If the kernel installs it in some known place, why 
should it not just read them from that known place?

		Linus
