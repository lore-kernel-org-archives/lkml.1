Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYCaRsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYCaRsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYCaRsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:48:17 -0400
Received: from rtr.ca ([76.10.145.34]:1844 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbYCaRsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:48:16 -0400
Message-ID: <47F123DF.10204@rtr.ca>
Date: Mon, 31 Mar 2008 13:48:15 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git5: Reported regressions from 2.6.24
References: <200803310228.11027.rjw@sisk.pl>
In-Reply-To: <200803310228.11027.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

Add this one to the list?


* * * * *

Subject: + driver-core-fix-uevent-action-string-regression.patch added to -mm tree
From: akpm
To: mm-commits
Date: 28/03/08 07:51 PM

The patch titled
     driver core: fix uevent action-string regression
has been added to the -mm tree.  Its filename is
     driver-core-fix-uevent-action-string-regression.patch
...

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver core: fix uevent action-string regression
From: Mark Lord <lkml@rtr.ca>

On boot, syslog is flooded with "uevent: unsupported action-string;" messages.
..
Mar 28 14:43:29 shrimp kernel: tty ptyqd: uevent: unsupported
action-string; this will be ignored in a future kernel version
Mar 28 14:43:29 shrimp kernel: tty ptyqe: uevent: unsupported
action-string; this will be ignored in a future kernel version
Mar 28 14:43:29 shrimp kernel: tty ptyqf: uevent: unsupported
action-string; this will be ignored in a future kernel version
Mar 28 14:43:29 shrimp kernel: tty ptyr0: uevent: unsupported
action-string; this will be ignored in a future kernel version


These messages are a regression compared with 2.6.24, which did not flood the
syslog with them.

The actual underlying problem was introduced in 2.6.23, when somebody made the
string parsing no longer accept nul-terminated strings as a valid input to
store_uevent().

Eg.  "add\0" was valid prior to 2.6.23, where the code regressed to require
"add" without the '\0'.

This patch fixes the 2.6.23 / 2.6.24 regressions, by having the code once
again tolerate the trailing '\0', if present.

According to GregKH, this mainly affects older Ubuntu systems, such as the one
I have here that requires this fix.

Signed-off-by: Mark Lord <mlord@pobox.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject_uevent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/kobject_uevent.c~driver-core-fix-uevent-action-string-regression lib/kobject_uevent.c
--- a/lib/kobject_uevent.c~driver-core-fix-uevent-action-string-regression
+++ a/lib/kobject_uevent.c
@@ -59,7 +59,7 @@ int kobject_action_type(const char *buf,
 	enum kobject_action action;
 	int ret = -EINVAL;
 
-	if (count && buf[count-1] == '\n')
+	if (count && (buf[count-1] == '\n' || buf[count-1] == '\0'))
 		count--;
 
 	if (!count)
_

Patches currently in -mm which might be from lkml@rtr.ca are

driver-core-fix-uevent-action-string-regression.patch
