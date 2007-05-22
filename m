Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbXEVQ30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbXEVQ30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbXEVQ3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:29:18 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:44758 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbXEVQ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:29:17 -0400
Date: Tue, 22 May 2007 18:28:12 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH] /sys/block -> /sys/class/block  (Fedora 3 & 4
 testers wanted)
Message-ID: <20070522182812.79b53880@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070522102501.72f40828@gondolin.boeblingen.de.ibm.com>
References: <20070521235353.GA6242@kroah.com>
	<20070522102501.72f40828@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 10:25:01 +0200,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> I tried this on one of our internal drivers, which is based on FC 3 (or
> 4, can look this up). With s390 defconfig, it is unable to open the
> root device /dev/dasda1 (which is unsurprising, considering udev (063)
> decided to create /dev/dasda(1) as a character node instead of a block
> node).

Just to be clear, it's fsck that complains:

Checking filesystems  
Checking all file systems.  
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/dasda1   
fsck.ext3: No such device or address while trying to open /dev/dasda1   
Possibly non-existent or swap device?  
[FAILED]   

(so that is after udev has been started and obviously dasda1 could be
accessed)

> When I look at the system, /sys/block/ and /sys/class/block/ look sane
> at first glance (working on a 3270 console is usally PITA...)
> 
> Even more surprisingly, the system comes up fine (once I added ptmx to
> makedev.d/) with CONFIG_SYSFS_DEPRECATED not set. /sys/block/
> and /sys/class/block/ look just like expected. (Unfortunately, our
> lsdasd tool breaks with this...)
> 
> I'll see if I can find out more.

I currently have the inkling that

lrwxrwxrwx  1 root root    0 May 22 15:59 block:dasda1-> ../../../class/block/dasda1

in /sys/block/dasda/ is the culprit. In all other versions I've tried
(without CONFIG_SYSFS_DEPRECATED, and on an older kernel with and
without CONFIG_SYSFS_DEPRECATED), it's always dasda1.

I can continue investigating tomorrow, unless someone has a good idea :)
