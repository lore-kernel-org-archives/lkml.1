Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYKOLgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYKOLgn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 06:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYKOLgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 06:36:35 -0500
Received: from mail.ukfsn.org ([77.75.108.10]:47417 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbYKOLge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 06:36:34 -0500
Date: Sat, 15 Nov 2008 11:36:25 +0000
From: Nick Warne <nick@ukfsn.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i8046:  unbind/bind issue with laptop system password set
Message-ID: <20081115113625.2dd959cd@palantir.linicks.net>
In-Reply-To: <20081114151849.GA27298@srcf.ucam.org>
References: <20081114123058.4e7db857@palantir.linicks.net>
	<20081114151849.GA27298@srcf.ucam.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 15:18:49 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Fri, Nov 14, 2008 at 12:30:58PM +0000, Nick Warne wrote:
> > Now, investigating further, I have found that I can replicate this
> > whole issue with this script:
> > 
> > #!/bin/sh
> > echo -n "i8042" > /sys/bus/platform/drivers/i8042/unbind
> > sleep 5;
> > echo -n "i8042" > /sys/bus/platform/drivers/i8042/bind
> > 
> > if I hit a key during the sleep stage, the keyboard et al all goes
> > AWOL again.
> > 
> > So, I am presuming here that when my laptop gets woken up, the BIOS
> > system password screen comes, and the /etc/acpi/resume.d/ scripts
> > are being held in stasis until I enter the password.  BUT, I have
> > then used the keyboard before i8042 is echoed to 'bind', and this
> > causes the issue.  Without the system password set, the scipts
> > perhaps run fast enough before I can hit the keyboard in this
> > keyboard state.
> 
> Why are you binding/unbinding the keyboard? That destroys the kernel 
> state about the mode the keyboard is in, and when the BIOS programs
> your keyboard into RAW mode for the BIOS password the kernel will
> assume that it should be treating it in raw mode on replug.
> 

OK, I found out what is going on - this is a Ubuntu hack reference this
bug:

https://bugs.launchpad.net/ubuntu/+source/acpi-support/+bug/23497

It appears default Ubuntu Gnome/KDE desktop power management render
some peoples keyboard useless after a resume, so the echo i8042 >
unbind/bind fixed it up for them.

As I do not use a desktop environment, just Fluxbox window manager, this
'hack' actually does the opposite and renders my keyboard useless.  So,
just removing these scripts fixes it up, and everything all works
perfectly now.

Sorry for the noise.

Nick

-- 
Free Software Foundation Associate Member 5508
