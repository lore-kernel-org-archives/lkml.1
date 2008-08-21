Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbYHUPxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbYHUPxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYHUPwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:52:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:60827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYHUPww convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:52:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: [PATCH 05/10] AXFS: axfs_profiling.c
Date: Thu, 21 Aug 2008 17:50:44 +0200
User-Agent: KMail/1.9.9
Cc: "David Woodhouse" <dwmw2@infradead.org>, carsteno@de.ibm.com,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?utf-8?q?J=C3=B6rn?= Engel" <joern@logfs.org>
References: <48AD00F8.1030004@gmail.com> <200808211706.37761.arnd@arndb.de> <6934efce0808210817h489bbeafyaf27217ca68bd31e@mail.gmail.com>
In-Reply-To: <6934efce0808210817h489bbeafyaf27217ca68bd31e@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808211750.45559.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19qCpOW6ifxM6LZd48KhRgtrwGOJSKZq2hZUAL
 fUTrfwdDNFlm6HKq3ae1BQRh9UFGy69Ub4gTnD3vHgMX2wBbO9
 7w6zGEm4ZVilYJckCNnVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Jared Hulbert wrote:
> So /sys/kernel/debug/axfs/volume0 would work?
> 
> > 4) no profiling at all
> > The profiling code has certainly been useful to you during development,
> > and you should keep that code around for your own work on it,
> > but maybe you should not push that upstream, because regular users
> > are not going to need it.
> 
> Nope.  Profiling is absolutely fundamental to how AXFS works.  Read
> the [PATCH 00/10] thread again.

Ok, understood it now. So it actually is a stable interface into
the file system, which means that debugfs might not be the best
solution.

I need to think about this some more. So far none of the options
are perfect. What I can think of so far includes:

1. An ioctl on the mount point of the fs
2. An ioctl that you need to call on each file
3. sysfs files is /sys/fs/axfs/
4. A new virtual file system to be mounted to /sys/fs/axfs/
5. A file below the device in sysfs, e.g. /sys/block/mtdblk0/axfs-profile

I've also taken a look at the format of the profiling data file.
I'm not sure that it is ideal if you want to be able to share
identical data blocks between files. Do you currently do that
in your mkfs? The fs format certainly allows it. I would expect
that if you checksum each page, you can find duplicates on a page
basis and save some space this way. However, it can make profiling
harder if you count based on blocks but report the data based on
the file name. Not sure what a better solution would look like.

	Arnd <><
