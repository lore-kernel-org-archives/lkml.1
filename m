Return-Path: <linux-kernel-owner+w=401wt.eu-S1765444AbZD3RRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765444AbZD3RRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764540AbZD3RHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:40 -0400
Received: from kroah.org ([198.145.64.141]:56319 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764410AbZD3RHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:31 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:41 2009
Message-Id: <20090430165741.547954347@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:11 -0700
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
       alan@lxorguk.ukuu.org.uk, Dan Carpenter <error27@gmail.com>,
       Len Brown <len.brown@intel.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 22/88] dock: fix dereference after kfree()
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0013-dock-fix-dereference-after-kfree.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Carpenter <error27@gmail.com>

upstream commit: f240729832dff3785104d950dad2d3ced4387f6d

dock_remove() calls kfree() on dock_station so we should use
list_for_each_entry_safe() to avoid dereferencing freed memory.

Found by smatch (http://repo.or.cz/w/smatch.git/).  Compile tested.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/acpi/dock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -1146,9 +1146,10 @@ static int __init dock_init(void)
 static void __exit dock_exit(void)
 {
 	struct dock_station *dock_station;
+	struct dock_station *tmp;
 
 	unregister_acpi_bus_notifier(&dock_acpi_notifier);
-	list_for_each_entry(dock_station, &dock_stations, sibiling)
+	list_for_each_entry_safe(dock_station, tmp, &dock_stations, sibiling)
 		dock_remove(dock_station);
 }
 


