Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYKTMrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYKTMrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 07:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbYKTMri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 07:47:38 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:36192 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbYKTMrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 07:47:37 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2008 07:47:37 EST
Subject: Crash during suspend to disk
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <account@cs.aau.dk>
To: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Nov 2008 13:41:56 +0100
Message-Id: <1227184916.4855.31.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I hope this information is sufficient to debug my problem, though it
unfortunately is somewhat incomplete. I took two pictures of the OOPS
with my mobile phone, but unfortunately the picture of the upper part is
so blurred that it is unreadable. Apparently I have to be in a hurry
getting out of the door for this to happen. Here is what I got from the
lower part

Call Trace:
  __blkdev_put
  swsusp_write
  hibernate
  state_store
  state_store
  state_store
  kobj_attr_store
  sysfs_write_file
  sysfs_write_file
  vfs_write
  sys_write
  sysenter_do_call
Code: ......
EIP: [<...>] iput
---[ end trace ........................... ]---

There is a lot of blanks here that I should be able provide on request
as well.

The problem occured in my third attempt in quick succession to suspend
to disk. The first two did not succeed due to insufficient free swap. I
got 768 MB ram and a ~1 GB swap partition. I believe top said something
like Mem: 3xxxxxk used and Swap: 6xxxxxk used before the third attempt
to suspend to disk.

The system that was running had at least one successful suspend to disk
and restore the day before and I also use it sucessfully on a daily
basis.

I believe I've seen the same crash before with a 2.6.27 or earlier
kernel, but I was in a hurry getting out of the door back then as I was
here. Circumstances was the same though, with already successful suspend
to disk and the crash appearing during second or third attempt to
suspend to disk in quick succession.

I guess I should be able to reproduce the crash with some efforts, but
I'd like to hear your thoughts on this before I do that.

Filesystems are reiserfs.


Simon Holm Thøgersen

