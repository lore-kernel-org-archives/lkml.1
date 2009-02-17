Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbZBQIpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbZBQIpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbZBQIpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:45:30 -0500
Received: from chmailsrv.int.mrv.com ([66.43.110.11]:37539 "EHLO
	chmailsrv.int.mrv.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751031AbZBQIpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:45:30 -0500
Date: Tue, 17 Feb 2009 00:45:27 -0800
From: Nye Liu <nyet@mrv.com>
To: linux-kernel@vger.kernel.org, nyet@nyet.org
Subject: [PATCH] modules: hid id->bus needs TO_NATIVE() in
	scripts/mod/file2alias.c
Message-ID: <20090217084523.GA3623@mrv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 17 Feb 2009 08:47:51.0611 (UTC) FILETIME=[6AD1D0B0:01C990DC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nye Liu <nyet@mrv.com>

When building a module alias, the bus identifier must be converted to
native endianness. The hid bus id entries were not being properly
swapped in little endian systems.

For example:

    # modinfo hid_dell
    filename:
    /lib/modules/2.6.28-1-amd64/kernel/drivers/hid/hid-dell.ko
    license: GPL
    alias: hid:b0300v000013BAp00000017
    alias: hid:b0300v0000413Cp00002105
    alias: hid:b0300v0000413Cp00002005
    depends: hid,usbhid

b0300 should read b0003

Signed-off-by: Nye Liu <nyet@mrv.com>

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 491b8b1..4eea60b 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -210,6 +210,7 @@ static void do_usb_table(void *symval, unsigned long size,
 static int do_hid_entry(const char *filename,
                             struct hid_device_id *id, char *alias)
 {
+       id->bus = TO_NATIVE(id->bus);
        id->vendor = TO_NATIVE(id->vendor);
        id->product = TO_NATIVE(id->product);
 

-- 
Nye Liu
nliu@mrv.com
(818) 772-6235x248
(818) 772-0576 fax

"Who would be stupid enough to quote a fictitious character?"
	-- Don Quixote
