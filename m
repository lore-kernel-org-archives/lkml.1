Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYGVXWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYGVXWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbYGVXS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:18:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756248AbYGVXSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:18:24 -0400
Date: Tue, 22 Jul 2008 16:15:05 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Klaus S. Madsen" <ubuntu@hjernemadsen.org>,
       Chuck Short <zulcss@ubuntu.com>, Jean Delvare <khali@linux-fr.org>,
       Tim Gardner <tim.gardner@canonical.com>,
       maximilian attems <max@stro.at>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Subject: [patch 14/47] hdaps: add support for various newer Lenovo thinkpads
Message-ID: <20080722231505.GO8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hdaps-add-support-for-various-newer-lenovo-thinkpads.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: maximilian attems <max@stro.at>

commit 292d73551d0aa19526c3417e791c529b49ebadf3 upstream

Adds R61, T61p, X61s, X61, Z61m, Z61p models to whitelist.

Fixes this:

cullen@lenny:~$ sudo modprobe hdaps
FATAL: Error inserting hdaps (/lib/modules/2.6.22-10-generic/kernel/drivers/hwmon/hdaps.ko): No such device

[25192.888000] hdaps: supported laptop not found!
[25192.888000] hdaps: driver init failed (ret=-19)!

Originally based on an Ubuntu patch that got it wrong, the dmidecode
output of the corresponding laptops shows LENOVO as the manufacturer.
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/133636

tested on X61s:
[  184.893588] hdaps: inverting axis readings.
[  184.893588] hdaps: LENOVO ThinkPad X61s detected.
[  184.893588] input: hdaps as /class/input/input12
[  184.924326] hdaps: driver successfully loaded.

Cc: Klaus S. Madsen <ubuntu@hjernemadsen.org>
Cc: Chuck Short <zulcss@ubuntu.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: maximilian attems <max@stro.at>
Cc: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/hdaps.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/hwmon/hdaps.c
+++ b/drivers/hwmon/hdaps.c
@@ -515,16 +515,24 @@ static struct dmi_system_id __initdata h
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R50"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R51"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R52"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61"),
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T41"),
 	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T42"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X41"),
 	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61s"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad Z60m"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61m"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61p"),
 	{ .ident = NULL }
 };
 

-- 
