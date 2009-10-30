Return-Path: <linux-kernel-owner+w=401wt.eu-S932877AbZJ3SrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbZJ3SrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 14:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932844AbZJ3SrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 14:47:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55815 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792AbZJ3SrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 14:47:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Help needed, Re: [Bug #14334] pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Date: Fri, 30 Oct 2009 19:48:24 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jose Marino" <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.EqH.Nse5KB@chimera>
In-Reply-To: <6dRYo8ss7vL.A.EqH.Nse5KB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910301948.24473.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 26 October 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).

Here's a puzzle for whoever likes hardware detective work.

Suspend to RAM worked just fine on the Jose's box before commit
53024df259e37ad49ee3d1f3721d4cecdd7bc357 (PM / yenta: Fix cardbus
suspend/resume regression, mainline commit
0c570cdeb8fdfcb354a3e9cd81bfc6a09c19de0c) that made the resume of CardBus
devices actually work.  After this commit, the box hangs during resume 100% of
the time.

We've done quite some debugging and here's the summary of findings:

1) Resume works if pcmcia_socket_dev_resume(dev) is moved to the "regular"
   resume phase, after resume_device_irqs().

2) Resume works if yenta_set_power() is not called during resume
   (from yenta_set_socket()).

3) It doesn't help to resume all ACPI devices before yenta.

4) It doesn't help to disable yenta events during resume (unconditionally).

5) There are two CardBus bridges in the box and according to the PM_TRACE
   information the _second_ one is the last device we attempt to wake up
   during a failing resume.

Please look into http://bugzilla.kernel.org/show_bug.cgi?id=14334 for details.

OK, any ideas anyone?

Rafael
