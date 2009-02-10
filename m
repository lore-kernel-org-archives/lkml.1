Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbZBJTKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbZBJTKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZBJTDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:47 -0500
Received: from kroah.org ([198.145.64.141]:53791 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755477AbZBJTDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:43 -0500
Date: Tue, 10 Feb 2009 11:00:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andy Whitcroft <apw@canonical.com>,
       Alan Cox <alan@redhat.com>,
       Matthew Burgess <matthew@linuxfromscratch.org>
Subject: [patch 18/53] serial: RS485 ioctl structure uses __u32 include
	linux/types.h
Message-ID: <20090210190017.GS14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline; filename="serial-rs485-ioctl-structure-uses-__u32-include-linux-types.h.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Andy Whitcroft <apw@canonical.com>

commit 60c20fb8c00a2b23308ae4517f145383bc66d291 upstream.

In the commit below a new struct serial_rs485 was introduced for a new
ioctl:

    commit c26c56c0f40e200e61d1390629c806f6adaffbcc
    Author: Alan Cox <alan@redhat.com>
    Date:   Mon Oct 13 10:37:48 2008 +0100

	tty: Cris has a nice RS485 ioctl so we should steal it

This structure uses the __u32 types for some of its members, which leads
to the following compile error:

    $ cc -I.../include -c X.c
    In file included from X.c:2: .../include/linux/serial.h:185:
		error: expected specifier-qualifier-list before ‘__u32’
    $

It seems that these types are appropriate for this structure as it is
to be exposed to userspace.  These types are available via linux/types.h
so move the include of that outside the __KERNEL__ section.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Burgess <matthew@linuxfromscratch.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 include/linux/serial.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -10,8 +10,9 @@
 #ifndef _LINUX_SERIAL_H
 #define _LINUX_SERIAL_H
 
-#ifdef __KERNEL__
 #include <linux/types.h>
+
+#ifdef __KERNEL__
 #include <asm/page.h>
 
 /*

