Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161Ab0AQQlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab0AQQlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 11:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073Ab0AQQlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 11:41:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58218 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab0AQQlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 11:41:51 -0500
Message-ID: <4B533E3E.9000304@gmail.com>
Date: Sun, 17 Jan 2010 17:43:42 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, apw@canonical.com, akpm@linux-foundation.org,
       dwalker@fifo99.com, Arjan van de Ven <arjan@infradead.org>,
       Pavel Machek <pavel@ucw.cz>, torvalds@linux-foundation.org
Subject: [PATCH] checkpatch.pl: Extend list of expected-to-be-const structures
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Based on Arjan's suggestion, extend the list of ops structures that should be const.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
--

 scripts/checkpatch.pl |   43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3257d3d..9494433 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2634,9 +2634,46 @@ sub process {
 		if ($line =~ /^.\s*__initcall\s*\(/) {
 			WARN("please use device_initcall() instead of __initcall()\n" . $herecurr);
 		}
-# check for struct file_operations, ensure they are const.
+# check for various ops structs, ensure they are const.
+		my $struct_ops = qr{acpi_dock_ops|
+				address_space_operations|
+				backlight_ops|
+				block_device_operations|
+				dentry_operations|
+				dev_pm_ops|
+				dma_map_ops|
+				extent_io_ops|
+				file_lock_operations|
+				file_operations|
+				hv_ops|
+				ide_dma_ops|
+				intel_dvo_dev_ops|
+				item_operations|
+				iwl_ops|
+				kgdb_arch|
+				kgdb_io|
+				kset_uevent_ops|
+				lock_manager_operations|
+				microcode_ops|
+				mtrr_ops|
+				neigh_ops|
+				nlmsvc_binding|
+				pci_raw_ops|
+				pipe_buf_operations|
+				platform_hibernation_ops|
+				platform_suspend_ops|
+				proto_ops|
+				rpc_pipe_ops|
+				seq_operations|
+				snd_ac97_build_ops|
+				soc_pcmcia_socket_ops|
+				stacktrace_ops|
+				sysfs_ops|
+				tty_operations|
+				usb_mon_operations|
+				wd_ops}x;
 		if ($line !~ /\bconst\b/ &&
-		    $line =~ /\bstruct\s+(file_operations|seq_operations)\b/) {
+		    $line =~ /\bstruct\s+($struct_ops)\b/) {
 			WARN("struct $1 should normally be const\n" .
 				$herecurr);
 		}


