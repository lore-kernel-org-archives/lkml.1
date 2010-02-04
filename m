Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab0BDHrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:47:12 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:43815 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab0BDHrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:47:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=date:from:to:cc
	:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=as+ypZ
	uFc9lOtXDXi1p3X/FFzph46H8iJRzDToKzW+svdtJK2XCP940WnsjBCx1n3hC82M
	5XdYMaxrge8AhthfFB36C8EYARpNZ8o0Y5FFCPO5T2RygSNmDcr1PE+Ozm0ygySv
	CDv+pS2XMxoVa/XwxQjxn3uJlWD1s5JYMVxL0=
Date: Thu, 4 Feb 2010 01:46:53 -0600
From: Corey Wright <undefined@pobox.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: regression in 2.6.27.45 with usb and suspend-to-disk
Message-Id: <20100204014653.1ed6b9e3.undefined@pobox.com>
In-Reply-To: <Pine.LNX.4.44L0.1002031521160.1321-100000@iolanthe.rowland.org>
References: <20100203134755.a56e2314.undefined@pobox.com>
 <Pine.LNX.4.44L0.1002031521160.1321-100000@iolanthe.rowland.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 7A11EDBA-1161-11DF-9C3E-6AF7ED7EF46B-06295150!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010 15:31:49 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 3 Feb 2010, Corey Wright wrote:
> 
> > the device is a usb SD reader w/ SD card in it.
> > 
> > # cat /sys/bus/usb/devices/1-8/product
> > USB 2.0  SD MMC READER 
> > 
> > i removed the media reader after the failed suspend (it is only used at
> > boot-up to hold the LUKS key material to decrypt the filesystem) but the
> > message is the same:
> > 
> > [ 4002.585329] ehci_hcd 0000:00:10.4: suspend root hub
> > [ 4002.585334] ehci_hcd 0000:00:10.4: suspend failed because port 8 is
> > resuming
> > [ 4002.585338] usb usb1: bus suspend fail, err -16
> > 
> > and /sys/bus/usb/devices/1-8 no longer exists (little
> > alone /sys/bus/usb/devices/1-8/power/wakeup):
> > 
> > # ls -1 /sys/bus/usb/devices/
> > 1-0:1.0
> > 1-7
> > 1-7:1.0
> > 2-0:1.0
> > 2-1
> > 2-1:1.0
> > 3-0:1.0
> > 4-0:1.0
> > 5-0:1.0
> > usb1
> > usb2
> > usb3
> > usb4
> > usb5
> > 
> > > And what happens if you do:
> > > 
> > > 	echo disabled >/sys/bus/usb/devices/1-8/power/wakeup
> > > 
> > > before trying to hibernate?
> > 
> > it's the same immediately after a reboot (and before suspending), a
> > successful suspend, or a failed suspend:
> > 
> > # echo disabled >/sys/bus/usb/devices/1-8/power/wakeup 
> > bash: echo: write error: Invalid argument
> > 
> > and as previously said, that sysfs entry does not exist if the media
> > reader is removed, though the error appears to continue to refer to that
> > port/device.
> 
> Okay, thanks for testing.  That narrows it down, and I believe the 
> patch below will fix the bug.  Let me know how it works.

after applying the patch the system suspended successfully three times in a
row (before i got tired of watching it resume, which takes minutes due to
bios hardware initialization).

i looked in dmesg after a suspend and all the usb debug messages looked
innocuous.

the patch appears to have fixed the problem.  i need to rebuild the
netbook's kernel with the new patch and see if that fixes it, too.  if it
doesn't fix the netboot suspending, then i'll follow-up.

thanks for your time debugging the problem and for the patch!

corey
-- 
undefined@pobox.com
