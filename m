Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbXJOGIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbXJOGIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 02:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbXJOGIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 02:08:16 -0400
Received: from outbound0.mx.meer.net ([209.157.153.23]:3457 "EHLO
	outbound0.sv.meer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbXJOGIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 02:08:15 -0400
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Hitachi disk: spurious completions during NCQ
References: <9cP6K-6rV-29@gated-at.bofh.it>
From: Don Mullis <dwm@meer.net>
Date: Sun, 14 Oct 2007 23:07:51 -0700
In-Reply-To: <9cP6K-6rV-29@gated-at.bofh.it> (Luca Tettamanti's message of "Wed\, 10 Oct 2007 21\:10\:22 +0200")
Message-ID: <87zlyksyfc.fsf@meer.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> ata3.00: spurious completions during NCQ issue=0x0 SAct=0x407fd FIS=005040a1:00020000
> ata3.00: cmd 61/08:00:c7:5a:82/00:00:1b:00:00/40 tag 0 cdb 0x0 data 4096 out
>          res 50/00:10:07:5b:82/00:00:1b:00:00/40 Emask 0x2 (HSM violation)


This has been seen with several Hitachi drives.  There's speculation
that it's due to a bug in the drive firmware:

http://groups.google.it/group/linux.kernel/browse_thread/thread/a4bd3c19565a2009/389817602f0cd551?hl=it&lnk=st&q=hitachi+hsm+violation&rnum=3#389817602f0cd551
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/137470


A workaround:

Index: /etc/rc.local
===================================================================
--- .orig/etc/rc.local  2007-10-13 14:57:10.000000000 -0700
+++ /etc/rc.local       2007-10-13 14:59:21.000000000 -0700
@@ -11,4 +11,7 @@
 #
 # By default this script does nothing.

+# See https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/137470/
+echo 1 > /sys/block/sda/device/queue_depth
+
 exit 0
