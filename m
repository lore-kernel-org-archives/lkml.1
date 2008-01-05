Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYAFAEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYAFAEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYAFAEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:04:16 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42297 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753058AbYAFAEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:04:15 -0500
Date: Sun, 6 Jan 2008 00:30:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: acpi/apm events as inputs: how to handle?
Message-ID: <20080105233011.GA1883@elf.ucw.cz>
References: <477B5FD8.5070503@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477B5FD8.5070503@msgid.tls.msk.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-01-02 12:56:40, Michael Tokarev wrote:
> (Not so) recently, ACPI events started appearing as
> key press events over linux input subsystem.  The
> question regarding this is simple: how it's supposed
> to be handled?
> 
> First of all, I don't know any software so far that
> can handle input layer in userspace when not running
> X.  In X, it's usually done using window manager
> setup or with special application (like, volume
> up/down keys etc).  But without X, there's no such
> application, as far as I can see.
> 
> It's easy to write one, but there may be.. issues
> with finding which input device to use.
> 
> Now, linux already have hotplug subsystem, using
> /sbin/hotplug helper (or whatever it points to,
> or using netlink).  ACPI key events are rare.
> 
> What I'm thinking about is: why ACPI events are
> routed over input subsystem, instead of hotplug
> subsystem?  With input, there's a need for a
> special daemon/application listening on the
> specific "keyboard" device, while with hotplug
> subsystem, it's already here - linux (by default
> anyway, if not running udev etc), kernel fires
> up a script when an event occurs.  I don't see
> how this special application/daemon is different
> from ol'good acpid.
> 
> Or.. maybe I missed something?

No, you are not missing anything. Yes, we could use /sbin/hotplug, but
it would be an ugly hack. So better write that daemon, or teach udevd
to read from input...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
