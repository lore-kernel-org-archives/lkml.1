Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbXJ3MvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbXJ3MvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 08:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXJ3MvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 08:51:10 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58600 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbXJ3MvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 08:51:09 -0400
Date: Tue, 30 Oct 2007 08:51:08 -0400
To: Josh Boyer <jwboyer@gmail.com>
Cc: Stefan Roese <stefan.roese@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Bootup support for watchdog with short timeout (touch_nmi_watchdog()?)
Message-ID: <20071030125108.GC27643@csclub.uwaterloo.ca>
References: <200710291522.27311.stefan.roese@gmail.com> <20071029194503.GB27646@csclub.uwaterloo.ca> <20071029215454.0d644ca7@vader.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029215454.0d644ca7@vader.jdub.homelinux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 09:54:54PM -0500, Josh Boyer wrote:
> To some degree, it's configurable.  But the generic question still
> stands.  It seems like a decent idea to me.  Making touch_watchdog (or
> whatever it winds up being called) nice across arches might be fun.

It always seemed to me that it was userspace that should poke the
watchdog as an indication user space still works on the system.  That's
how my watchdogs are managed.  I do initialize them in the boot loader
with a 3 minute timeout which is more than long enough for the system to
boot, load the driver and change the timeout to 60 seconds or whatever
I want at runtime and start the watchdog daemon.

If the kernel hangs at initializing some driver, I do NOT want the
kernel to automatically be poking the watchdog.  I want it to time out
so to me the kernel should not be able to kick the watchdog at all by
itself.

--
Len Sorensen
