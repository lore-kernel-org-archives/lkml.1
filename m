Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZK0TJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZK0TJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 14:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZK0TJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 14:09:20 -0500
Received: from outside.256.com ([72.93.100.124]:63091 "EHLO outside.256.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZK0TJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 14:09:20 -0500
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Nov 2009 14:09:20 EST
Message-Id: <m1NE61t-004yeQC@outside.256.com>
Date: Fri, 27 Nov 2009 13:58:53 -0500 (EST)
To: linux-kernel@vger.kernel.org
From: jgj7.ignorantguru@mailnull.com
Subject: blowfish and cryptoloop modules question
X-Forward: linux-kernel@vger.kernel.org via outside.256.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question for the maintainer of these modules or losetup but haven't been able to find an address.  I posted this to an Arch forum but no one could explain it.  

I don't need my entire hard drive encrypted so my habit is to create a small blowfish container using the cryptoloop and blowfish kernel modules.  Something like:

Code:

## Load modules
/sbin/modprobe cryptoloop
/sbin/modprobe blowfish
## Make file "secfilename"
dd if=/dev/urandom of=secfilename bs=1024k count=10
## Set file as target of loop device
losetup -e blowfish /dev/loop0 secfilename
## Make ext3 filesystem
mkfs -t ext3 /dev/loop0
## Mount filesystem
mount -t ext3 /dev/loop0 /mnt/loop
#...
## Unmount, detach, and sync
umount /dev/loop0
## Detach loop device
losetup -d /dev/loop0
sync

Here's my question:  A long time ago, when I changed from SUSE to Ubuntu, I could no longer mount the container - it said there was no valid FS on it.  So I had to recreate it.  This made me question SUSE's blowfish implementation - was it crippled or have a backdoor?  Now, years later I have installed Arch, and once again my container wasn't portable.  Arch couldn't open Ubuntu's blowfish container.  I had to recreate it from scratch with the 'new' blowfish.

Will the real blowfish please stand up.

Needless to say, this makes me question the integrity of these modules.  A cryptographic algorithm, if properly implemented, should not be distro-centric.  For my purposes it's probably not critical, but what's going on?  I can mount my unencrypted ext3 partitions created by Ubuntu fine in Arch.  Why are the blowfish modules not compatible?

And if they are, then why is losetup so inconsistent between distributions?

If they aren't compatible for a legitimate reason, I think they should be, as using different implementations is the only way users can verify an implementation.

Thanks for any info.


----------
This message was sent from a MailNull anti-spam account.  You can get
your free account and take control over your email by visiting the
following URL.

   http://mailnull.com/
