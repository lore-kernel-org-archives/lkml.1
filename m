Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbXHGVFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbXHGVFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935521AbXHGUw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:52:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56437 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935654AbXHGUw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:52:26 -0400
Date: Tue, 7 Aug 2007 13:45:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, drepper@redhat.com
Subject: [2.6.22.2 review 36/84] CPU online file permission
Message-ID: <20070807204554.GL23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cpu-online-file-permission.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ulrich Drepper <drepper@redhat.com>

Is there a reason why the "online" file in the subdirectories for the CPUs
in /sys/devices/system isn't world-readable?  I cannot imagine it to be
security relevant especially now that a getcpu() syscall can be used to
determine what CPUa thread runs on.

The file is useful to correctly implement the sysconf() function to return
the number of online CPUs.  In the presence of hotplug we currently cannot
provide this information.  The patch below should to it.

Signed-off-by: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -53,7 +53,7 @@ static ssize_t store_online(struct sys_d
 		ret = count;
 	return ret;
 }
-static SYSDEV_ATTR(online, 0600, show_online, store_online);
+static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
 static void __devinit register_cpu_control(struct cpu *cpu)
 {

-- 
