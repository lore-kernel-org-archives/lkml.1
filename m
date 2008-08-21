Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbYHUPJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbYHUPJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYHUPJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:09:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59029 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbYHUPJg convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:09:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: [PATCH 05/10] AXFS: axfs_profiling.c
Date: Thu, 21 Aug 2008 17:06:36 +0200
User-Agent: KMail/1.9.9
Cc: "David Woodhouse" <dwmw2@infradead.org>, carsteno@de.ibm.com,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?utf-8?q?J=C3=B6rn?= Engel" <joern@logfs.org>
References: <48AD00F8.1030004@gmail.com> <200808211339.37187.arnd@arndb.de> <6934efce0808210755n1977e085o63b8b91e84575dc9@mail.gmail.com>
In-Reply-To: <6934efce0808210755n1977e085o63b8b91e84575dc9@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808211706.37761.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/2cGGTxdqcCRTBO5dFUJgIh/9BvxO48dxnFDB
 hZq0ZVu16x3+MKSIGbBRoTBB8ctlaz32LfCWAmGPc+gCYDCBIN
 TE2ybpnNQ2bLb6eSWeM0w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Jared Hulbert wrote:

> 1) same mount point -
> I don't see how this works without an ioctl.  I can't just make up
> files in my mounted filesystem.   You expect the mounted version to
> match input to the mkfs.  I'd not be happy with an ioctl.  You can
> just read it.

I think what Carsten was suggesting is that you create extra files
in the file system that behave like your current procfs files.
This limits the choice for names inside of the file system, and
therefor I think should not be done.
 
> 2) sysfs -
> I agree with Carsten, I don't see how this fits in the sysfs hierarchy.

You can create attributes below the device you have mounted.
Technically possible, the main issue I see with this is having
to maintain ABI compatibility.

> 3) debugfs -
> I don't know diddly about this.
> 
> So why not /proc?

/proc has the same ABI restrictions as sysfs. We more or less stopped
allowing new files in /proc some 5 years ago for this reason. I didn't
even read beyond the word /proc to know that what you do here is wrong.
debugfs is normally easier to use than procfs as well, you just
define some file_operations with read/write callbacks and call
debugfs_create_file with the path name below /sys/kernel/debug.

If I may give yet another suggestion:

4) no profiling at all
The profiling code has certainly been useful to you during development,
and you should keep that code around for your own work on it,
but maybe you should not push that upstream, because regular users
are not going to need it.

	Arnd <><
