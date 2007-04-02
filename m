Return-Path: <linux-kernel-owner+w=401wt.eu-S966096AbXDBXUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966096AbXDBXUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 19:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966098AbXDBXUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 19:20:15 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:34300 "EHLO
	outbound4-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966096AbXDBXUN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 19:20:13 -0400
X-BigFish: VP
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Warning: unable to open an initial console.
Date: Mon, 2 Apr 2007 16:20:06 -0700
In-Reply-To: <20070402224923.GA11208@tuatara.stupidest.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Warning: unable to open an initial console.
Thread-Index: Acd1eTiM0lZvLHNmRWKBaqMX7oT9GwAAYcDQ
References: <20070402190458.0EDD039005F@mail42-fra.bigfish.com> <20070402224923.GA11208@tuatara.stupidest.org>
From: "Tom Strader" <tom.strader@xilinx.com>
To: "Chris Wedgwood" <cw@f00f.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Apr 2007 23:20:07.0074 (UTC) FILETIME=[73657820:01C7757D]
Message-Id: <20070402232012.6716E64781D@mail78-cpk.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I checked /dev/ with U-boot and it shows the existence of /dev/console.

>From U-boot prompt:

$ ls /dev
 crw-------        0 Mon Apr 02 17:52:27 2007 console
 crw-r--r--        0 Mon Apr 02 17:52:27 2007 null
 crw-r--r--        0 Mon Apr 02 17:52:27 2007 zero


Also, I added a printk in the jffs2_add_fd_to_list() routine in
fs/jffs2/nodelist.c to print out the dirent adds and it shows console
being added as follows:

...
add dirent "var", ino #14
add dirent "usr", ino #13
add dirent "tmp", ino #12
add dirent "sys", ino #11
add dirent "sbin", ino #10
add dirent "proc", ino #9
add dirent "mnt", ino #8
add dirent "linuxrc", ino #7
add dirent "lib", ino #6
add dirent "home", ino #5
add dirent "etc", ino #4
add dirent "dev", ino #3
add dirent "bin", ino #2
VFS: Mounted root (jffs2 filesystem).
Freeing init memory: 76K
add dirent "zero", ino #70
add dirent "null", ino #69
add dirent "console", ino #68
Warning: unable to open an initial console.
add dirent "watchdog", ino #262
add dirent "udevstart", ino #261
add dirent "udevsend", ino #260
...

Any other ideas?
Thanks,
Tom


-----Original Message-----
From: Chris Wedgwood [mailto:cw@f00f.org] 
Sent: Monday, April 02, 2007 3:49 PM
To: Tom Strader
Cc: linux-kernel@vger.kernel.org
Subject: Re: Warning: unable to open an initial console.

On Mon, Apr 02, 2007 at 12:04:56PM -0700, Tom Strader wrote:

> I have seen quite a few posts regarding unable to open an initial
> console, but my system seems to have the necessary things in place
> so I come looking for help.

your rootfs/initramfs/initrd is missing a valid working /dev/console

> VFS: Mounted root (jffs2 filesystem).

check /dev/ on this filesystem


