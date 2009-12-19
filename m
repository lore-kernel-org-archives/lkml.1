Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbZLSXjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbZLSXjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 18:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZLSXjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 18:39:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36100 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbZLSXjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 18:39:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async suspend-resume patch w/ rwsems)
Date: Sun, 20 Dec 2009 00:40:18 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912200010.19899.rjw@sisk.pl> <alpine.LFD.2.00.0912191521180.3712@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912191521180.3712@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912200040.18944.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 December 2009, Linus Torvalds wrote:
> 
> On Sun, 20 Dec 2009, Rafael J. Wysocki wrote:
> > 
> > Well, I guess this is the example of the off-tree dependencies that actually
> > matter Linus wanted. :-)
> 
> It's also the kind of dependency where I say "if we get into these kinds 
> of messes, then the whole async crap isn't worth it".
> 
> Really. Having to try to match things up with ACPI and PnP is a nightmare. 
> Especially since I doubt Windows does anything like this, which means that 
> there's no reason for BIOS vendors to do the tables so that we'd even 
> know.

OK, so this means we can just forget about suspending/resuming i8042
asynchronously, which is a pity, because that gave us some real suspend
speedup on my test systems.

Well, whatever.

So, seriously, do you think it makes sense to do asynchronous suspend at all?
I'm asking, because we're likely to get into troubles like this during suspend
for other kinds of devices too and without resolving them we won't get any
significant speedup from asynchronous suspend.

That said, to me it's definitely worth doing asynchronous resume with the
"start asynch threads upfront" modification, as the results of the tests show
that quite clearly.  I hope you agree.

Rafael
