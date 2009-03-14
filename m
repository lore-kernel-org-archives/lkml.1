Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbZCNBgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbZCNBgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZCNBUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:49 -0400
Received: from kroah.org ([198.145.64.141]:35196 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753380AbZCNBU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:38 2009
Message-Id: <20090314011038.052964195@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:22 -0700
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
       alan@lxorguk.ukuu.org.uk, Jiri Slaby <jirislaby@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [patch 045/114] HID: fix bus endianity in file2alias
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=hid-fix-bus-endianity-in-file2alias.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 2b639386a2a26c84c8d26c649cf657ebd43a7bc8 upstream.

Fix endianness of bus member of hid_device_id in modpost.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Reported-by: Nye Liu <nyet@mrv.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/mod/file2alias.c |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -210,6 +210,7 @@ static void do_usb_table(void *symval, u
 static int do_hid_entry(const char *filename,
 			     struct hid_device_id *id, char *alias)
 {
+	id->bus = TO_NATIVE(id->bus);
 	id->vendor = TO_NATIVE(id->vendor);
 	id->product = TO_NATIVE(id->product);
 


