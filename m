Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbXEVIZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbXEVIZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbXEVIZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:25:07 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:63801 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbXEVIZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:25:04 -0400
Date: Tue, 22 May 2007 10:25:01 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH] /sys/block -> /sys/class/block  (Fedora 3 & 4
 testers wanted)
Message-ID: <20070522102501.72f40828@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070521235353.GA6242@kroah.com>
References: <20070521235353.GA6242@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 16:53:53 -0700,
Greg KH <greg@kroah.com> wrote:

> So, could anyone still running the crufty and unsupported Fedora 3 and 4
> releases test this patch out and let us know if it boots your machine or
> not?  I don't want to break legacy distros if we can possibly help it.
> 
> This has been successfully tested on both SuSE and Gentoo boxes, so
> we do hope this works for others.

Unfortunately, it doesn't :(

I tried this on one of our internal drivers, which is based on FC 3 (or
4, can look this up). With s390 defconfig, it is unable to open the
root device /dev/dasda1 (which is unsurprising, considering udev (063)
decided to create /dev/dasda(1) as a character node instead of a block
node). The only udev rule I found which could affect the dasd device
nodes is

SUBSYSTEM=="block",             GROUP="disk", MODE="0640"

When I look at the system, /sys/block/ and /sys/class/block/ look sane
at first glance (working on a 3270 console is usally PITA...)

Even more surprisingly, the system comes up fine (once I added ptmx to
makedev.d/) with CONFIG_SYSFS_DEPRECATED not set. /sys/block/
and /sys/class/block/ look just like expected. (Unfortunately, our
lsdasd tool breaks with this...)

I'll see if I can find out more.
