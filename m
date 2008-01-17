Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbYAQQSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbYAQQSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 11:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYAQQR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 11:17:58 -0500
Received: from mail.physik.uni-muenchen.de ([192.54.42.129]:55019 "EHLO
	mail.physik.uni-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617AbYAQQR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 11:17:58 -0500
X-Greylist: delayed 1622 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2008 11:17:57 EST
Subject: kexec, initramdisk and dmcrypt questions
From: Christoph Anton Mitterer 
	<christoph.anton.mitterer@physik.uni-muenchen.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: =?ISO-8859-1?Q?Ludwig-Maximilians-Unive?=
	=?ISO-8859-1?Q?rsit=E4t?= =?ISO-8859-1?Q?_M=FCnchen?=
Date: Thu, 17 Jan 2008 16:50:53 +0100
Message-Id: <1200585053.3265.33.camel@etppc19>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'd like to setup a system where all partitions (including the root file
system) are encrypted using dmcrypt.
Of course I need some place where I can boot from, and I intended to use
an USB-stick for that purpose.

Now I think there are (at least) the following two ways of doing this:

1) Traditional way
Boot from the USB-Stick with and initramsdisk,.. that sets up dmcrypt
and mounts the root-filesystem.

-Has the advantages that it's pretty well supported by some distros
(e.g. Debian) and it's very easy to setup.
-Has the disadvantages, that I'll always have to update the contents of
the stick when I install a new kernel (btw: does anybody know of an
write-once USB-Stick? ;) )

After booting it should be possible to just plug out the stick (as the
kernel and the modules are already loaded), or not?



2) using kexec.
I could imagine that my USB-stick serves just as loader,... having a
kernel and initrd that sets up dmcrypt/mounts root and calls kexec for
the "real" working kernel and the corresponding initramdisk, that are
both stored encrypted on e.g. the root filesystem in /boot/ or so...
The initrd of the working kernel contains the dmcrypt keys and
automatically sets up the mappings and mounts the filesystems.

-Has the advantage that this is nearly transparent for the system,
especially for tools that automatically create the initramdisk (stuff
like update-initramfs in Debian)
-And I would (nearly) never have to change the contents of the
loader-USB-stick.

Now I've read through the kexec documentation and I wonder wheter using
kexec might have some negative impact?
As the firmware is already initialised (by the loader kernel??) and the
working kernel must be put on different addresses.

I'm also not sure how to use the "architecture options" from the kexec
userspace tools?

Any ideas, help, suggestions, or threads ;) ?

Thanks and best wishes,
Chris.

