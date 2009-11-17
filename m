Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbZKQRG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbZKQRG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZKQRG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:06:58 -0500
Received: from ns.firmix.at ([62.141.48.66]:3048 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbZKQRG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:06:57 -0500
Subject: O_NOATIME and files in /proc
From: Bernd Petrovitsch <bernd@firmix.at>
To: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 17 Nov 2009 18:06:29 +0100
Message-Id: <1258477590.16246.35.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.67 on ns.firmix.at
X-Firmix-Spam-Score: -2.286 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.286 required=5
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
X-Firmix-Received-Date: Tue, 17 Nov 2009 18:07:03 CET
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

Is there a specific reason that open can not open files (at
least /proc/noatime and /proc/cpuinfo) under /proc with NO_ATIME as the
following program shows:
----  snip  ----
{12}cat noatime.c

#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>

int main(void)
{
	int fd = open("/proc/uptime", O_RDONLY|O_NOATIME);
	if (fd == -1) {
		printf("fd=%d, errno=%s\n", fd, strerror(errno));
	} else {
		printf("fd=%d\n", fd);
	}
	return 0;
}
----  snip  ----
When I compile and run it, it prints
----  snip  ----
{13}./noatime 
fd=-1, errno=Operation not permitted
----  snip  ----
Removing the "NO_ATIME" makes it work (of course).

I can also set the "noatime" mount flag on a remount and it shows up
in /proc/mounts but it makes for the above no difference.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


