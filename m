Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZBBRVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZBBRVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZBBRVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:21:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34221 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbZBBRVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:21:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Date: Mon, 2 Feb 2009 18:20:19 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <1233568479.18767.86.camel@pasglop>
In-Reply-To: <1233568479.18767.86.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902021820.20450.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 February 2009, Benjamin Herrenschmidt wrote:
> On Mon, 2009-01-26 at 19:04 +0000, Linux Kernel Mailing List wrote:
> > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=aa8c6c93747f7b55fa11e1624fec8ca33763a805
> > Commit:     aa8c6c93747f7b55fa11e1624fec8ca33763a805
> > Parent:     0db29af1e767464d71b89410d61a1e5b668d0370
> > Author:     Rafael J. Wysocki <rjw@sisk.pl>
> > AuthorDate: Fri Jan 16 21:54:43 2009 +0100
> > Committer:  Jesse Barnes <jbarnes@virtuousgeek.org>
> > CommitDate: Fri Jan 16 12:57:58 2009 -0800
> > 
> >     PCI PM: Restore standard config registers of all devices early
> 
> This seems to break resume on some PowerBooks (just reported by
> Andreas).

Yes, I saw the report in Bugzilla.

> I'm not yet sure what's up, but I can imagine various problems with the
> approach. For one, pci_enable_device() is the only place where the arch
> has a hook to turn back on things like clocks etc... to a device. You
> aren't supposed to touch at the config space before the arch got a
> chance to turn things back on. I agree there's somewhat a chicken and
> egg problem here, so we might need to look more closely at what that
> restore thing does and maybe add a call to the arch low level enable
> hook first... Or create a new hook.

I'd prefer to create a new hook, althouth there may be a problem with ACPI
vs interrupts off.  In the meantime, I'd like to test some recent fixes on top
of this patch and try a couple of debug patches to see what's up (in the
Bugzilla if that's not a problem).

> I don't know how x86 does but I'm sure there must be some kind ACPI
> thingy that must be called too before you can touch a device, in case it
> got powered off by more than just the standard D states (ie, clock
> stopped on the bus or whole power plane switched off).
> 
> I'll try to reproduce and think about it more, but it looks to me that
> this patch might not be quite the right approach yet.

Yeah.

Well, the approach is a bit x86-ish ...

Thanks,
Rafael
