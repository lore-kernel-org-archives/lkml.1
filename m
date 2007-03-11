Return-Path: <linux-kernel-owner+w=401wt.eu-S965010AbXCKTYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010AbXCKTYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965016AbXCKTYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:24:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40724 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010AbXCKTY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:24:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: SwSusp to disk doesn't work - Try 2
Date: Sun, 11 Mar 2007 20:27:03 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <45F44599.3060508@m3y3r.de> <200703111926.20183.rjw@sisk.pl> <45F44C60.10201@m3y3r.de>
In-Reply-To: <45F44C60.10201@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703112027.03532.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 March 2007 19:37, Thomas Meyer wrote:
> Rafael J. Wysocki schrieb:
> >
> > Could you please put some printk()s in kernel/cpu.c:_cpu_up() to see where
> > it gets stuck?  I bet one of the notifiers goes to sleep (cpufreq, maybe).
> >   
> Here we go (ok. i forgot __FUNCTION__ ...):
> 
> Mar 11 19:31:33 [kernel] ac ACPI0003:00: freeze
> Mar 11 19:31:33 [kernel] acpi device:00: freeze
> Mar 11 19:31:33 [kernel] processor ACPI0007:01: freeze
> Mar 11 19:31:33 [kernel] processor ACPI0007:00: freeze
> Mar 11 19:31:33 [kernel] button button_power:00: freeze
> Mar 11 19:31:33 [kernel] acpi acpi_system:00: freeze
> Mar 11 19:31:33 [kernel] Disabling non-boot CPUs ...
> Mar 11 19:31:33 [kernel] kvm: disabling virtualization on CPU1
> Mar 11 19:31:33 [kernel] CPU 1 is now offline
> Mar 11 19:31:33 [kernel] SMP alternatives: switching to UP code
> Mar 11 19:31:33 [kernel] PM: Removing info for No Bus:cpu1
> Mar 11 19:31:33 [kernel] PM: Removing info for No Bus:msr1
> Mar 11 19:31:33 [kernel] CPU1 is down
> Mar 11 19:31:33 [kernel] swsusp debug: Waiting for 5 seconds.
> Mar 11 19:31:33 [kernel] Enabling non-boot CPUs ...
> Mar 11 19:31:33 [kernel] <NULL>: before notifier CPU_UP_PREPARE.
> 
> Hung here.

This means that one of the notifiers had not returned before you pressed
the button.  Now the question is which one (there are many).

I don't know if there's any nicer way to find out that, but I usually hack
kernel/sys.c:notifier_call_chain() to print nb->notifier_call (as a pointer)
before the call is made.  Then I write down the address of the last one
called before the hang/oops and use gdb to check which function it points to.

Greetings,
Rafael
