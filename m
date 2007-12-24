Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbXLXNZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbXLXNZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 08:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXLXNZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 08:25:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58991 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbXLXNZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 08:25:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM
Date: Mon, 24 Dec 2007 14:44:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <alpine.LFD.0.9999.0712231703390.21557@woody.linux-foundation.org> <200712240305.18080.carlos@strangeworlds.co.uk>
In-Reply-To: <200712240305.18080.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712241444.24031.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 24 of December 2007, Carlos Corbacho wrote:
> On Monday 24 December 2007 01:14:34 Linus Torvalds wrote:
> > Side note: we could obviously undo the commit that triggered this for you
> > [..]
> > In other words, we'd have to go back to our original ordering, which Len
> > said was fundamentally wrong. I don't think anybody really wants that.
> 
> Nor would I argue to do so.
> 
> > It would be better to figure out why "device_suspend()" apparently causes
> > problems for your AML crud.
> 
> Will do - thanks for the pointer.

Well, having considered that for a longer while, I think the AML code is
referring to a device that we have suspended already, and since it's in a low
power state, it just can't handle the reference.

If that is the case, we'll have to find the device (that should be possible
using some code instrumentation) and move the suspending of it into the late
stage.

> > Oh, and why is linux-kernel cc'd, but not linux-pm?
> 
> Because I like to compound my errors (I mean, if you're going to screw up, you 
> might as well _really_ go for it).

BTW, linux-pm is on linux-foundation, changed the CC. ;-)

Thanks,
Rafael
