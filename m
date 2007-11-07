Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXKGWCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXKGWCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758911AbXKGWCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:02:09 -0500
Received: from godel.catalyst.net.nz ([202.78.240.40]:47876 "EHLO
	mail1.catalyst.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859AbXKGWCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:02:07 -0500
X-Greylist: delayed 1921 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2007 17:02:07 EST
Message-ID: <47322E58.7000301@catalyst.net.nz>
Date: Thu, 08 Nov 2007 10:30:00 +1300
From: Sam Vilain <sam.vilain@catalyst.net.nz>
Organization: Catalyst IT (NZ) Ltd
User-Agent: Icedove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Serial console and the Sun X4100M2 ILOM
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We're using a PXE / network install system for the SunFire x4100M2.  We
had a kernel that worked fine for the x4100 and x2100/x2100M2, but this
new platform does something funny: after selecting the kernel at the
PXElinux prompt, I don't see any kernel messages on the serial console,
until the kernel has finished initialising.  They are appearing on the
VGA console, when I use console=tty0 console=ttyS0.  With console=ttyS0
only, they appear nowhere.

There is a BIOS setting called "Redirect" that has one option that looks
like a smoking gun: "Redirection After BIOS POST".  This has three settings:

  Disable: Turns off the redirection after POST
  Boot Loader: Redirection is active during POST and during Boot Loader.
  Always: Redirection is always active
  (Some OSs may not work if set to Always)

It seems that "always" is behaving just like "Boot Loader" says it
should - as soon as it would be saying "Loading kernel..." then I see no
messages at all.  Except perhaps a suprious character like "Á".

The "Boot Loader" option then works like "disable" - as soon as PXElinux
(or GRUB) loads, the console switches off and I see the "Á".

What's got me confounded is that it suddenly wiki comes right after root
gets mounted - be that an initrd image, or anything else.  What is it
that changes then, and how can I make that happen earlier?

I found the console.txt file, and it seems that while boot is in
progress the "system driver" is active vs the "modular driver".
However, I'm not sure why there is a change of driver at that point; I
didn't ask for it.

I'm coming to the conclusion that the serial console redirection in the
BIOS is broken somehow, anyone have any ideas on tracking this down further?
-- 
Sam Vilain, Chief Yak Shaver, Catalyst IT (NZ) Ltd.
phone: +64 4 499 2267        PGP ID: 0x66B25843
