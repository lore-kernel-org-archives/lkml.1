Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab0BCSAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:00:15 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:55554 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761Ab0BCSAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:00:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=date:from:to:cc
	:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=AhINhQ
	eqCh5px9ZoRQUHUzIdCe+4FkxCr8yu31uNwismh75oVnAwJ/8T74zXZv+uxNnUtN
	ta0+RJMJAq36WHcJ+slWEdtUR3zZTFlvF00vkpHmgjtjeEArXdIlZqGGJVSqdo5r
	yAaOsDb7tXFqLhxLP+11ApmVo1yc2+iTtc8rs=
Date: Wed, 3 Feb 2010 11:59:56 -0600
From: Corey Wright <undefined@pobox.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: regression in 2.6.27.45 with usb and suspend-to-disk
Message-Id: <20100203115956.cb479447.undefined@pobox.com>
In-Reply-To: <Pine.LNX.4.44L0.1002031004210.1540-100000@iolanthe.rowland.org>
References: <20100203032452.4c215f9f.undefined@pobox.com>
 <Pine.LNX.4.44L0.1002031004210.1540-100000@iolanthe.rowland.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Pobox-Relay-ID: F33921F0-10ED-11DF-AD1A-6AF7ED7EF46B-06295150!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 10:05:27 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 3 Feb 2010, Corey Wright wrote:
> 
> > 2.6.27.45 will only suspend-to-disk once without rebooting.  every
> > attempt to suspend-to-disk after the first attempt results in "pm_op():
> > usb_dev_freeze +0x0/0xa returns -16" and "PM: Device usb1 failed to
> > freeze: error -16".  reverting commit
> > 4fbebe26d7a5eed6c1900bf2142b68af7df38462
> > (http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=commit;h=4fbebe26d7a5eed6c1900bf2142b68af7df38462)
> > fixes the problem.
> > 
> > this problem exhibits itself on both a x86-64 desktop and i386 netbook
> > (though the reverted commit was only tested on the x86-64 desktop).  the
> > affected computers are different architectures, different distributions
> > (debian lenny vs ubuntu hardy), and different kernel configs (but
> > unchanged since 2.6.27.23), so i am fairly certain this is a regression
> > in 2.6.27.45 and not the result of an environment change.
> > 
> > i normally use the pm-hibernate command to suspend to disk, but to
> > isolate the problem i used the kernel interfaces directly (as
> > demonstrated in the transcript below).
> > 
> > i can provide any other information necessary (eg .config, dmesg, lsusb)
> > and i am willing to test patches.
> 
> Please build a kernel with CONFIG_USB_DEBUG enabled and post a dmesg 
> log showing the problem during the second hibernation attempt.

[  675.443474] PM: Syncing filesystems ... done.
[  675.576353] Freezing user space processes ... (elapsed 0.00 seconds)
done.
[  675.606968] Freezing remaining freezable tasks ... (elapsed 0.00
seconds) done.
[  675.629249] PM: Shrinking memory...  -\|done (3129 pages freed)
[  679.547522] PM: Freed 12516 kbytes in 3.90 seconds (3.20 MB/s)
[  679.565065] Suspending console(s) (use no_console_suspend to debug)
[  679.585425] uhci_hcd 0000:00:10.0: release dev 2 ep81-INT, period 8,
phase 4, 118 us
[  679.585453] hub 2-0:1.0: hub_suspend
[  679.585460] usb usb2: bus suspend
[  679.585463] usb usb2: suspend_rh
[  679.585534] hub 1-0:1.0: hub_suspend
[  679.585538] usb usb1: bus suspend
[  679.585542] ehci_hcd 0000:00:10.4: suspend root hub
[  679.585547] ehci_hcd 0000:00:10.4: suspend failed because port 8 is
resuming
[  679.585551] usb usb1: bus suspend fail, err -16
[  679.585554] hub 1-0:1.0: hub_resume
[  679.585585] hub 1-0:1.0: port 7: status 0503 change 0000
[  679.585590] hub 1-0:1.0: port 8: status 0503 change 0000
[  679.585595] pm_op(): usb_dev_freeze+0x0/0xa returns -16
[  679.585607] PM: Device usb1 failed to freeze: error -16
[  679.585696] usb usb2: usb resume
[  679.585699] usb usb2: wakeup_rh
[  679.624016] hub 2-0:1.0: hub_resume
[  679.624026] hub 2-0:1.0: port 1: status 0303 change 0000
[  679.624051] uhci_hcd 0000:00:10.0: reserve dev 2 ep81-INT, period 8,
phase 4, 118 us
[  679.722862] Restarting tasks ... <7>hub 1-0:1.0: state 7 ports 8 chg
0000 evt 0000
[  679.747221] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[  679.747251] done.

corey
-- 
undefined@pobox.com
