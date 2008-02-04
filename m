Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbYBDDNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbYBDDNI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 22:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYBDDM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 22:12:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:34069 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYBDDM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 22:12:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=W0WHoVHCFObi3nD9AuzaXzPpe3Amd7lFwkJgOfdcf2ER3ujHZQko7OwX9lUF2XxU6UcHKWoyRQg+kopoUONUKJHMLSRvllCJ/qL4k0tX4ABNoI7Typ0FunV5N/AAP53cmw/Ayj3obfQK5GEpJfjBALMnqxtUz+A/rZMGsy5LpQ8=
Message-ID: <804dabb00802031912p15a61ff3ldf669592450c1117@mail.gmail.com>
Date: Mon, 4 Feb 2008 11:12:55 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Section mismatch: kernel/relay.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is to fix the following warning (see earlier email):

WARNING: kernel/built-in.o(.data+0x7c00): Section mismatch in
reference from the variable relay_hotcpu_callback_nb.18789 to the
function .cpuinit.text:relay_hotcpu_callback()
The variable relay_hotcpu_callback_nb.18789 references
the function __cpuinit relay_hotcpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>

--- relay.c.orig        2008-02-04 10:49:41.000000000 +0800
+++ relay.c     2008-02-04 10:50:53.000000000 +0800
@@ -477,7 +477,7 @@ static void setup_callbacks(struct rchan
  *
  *     Returns the success/failure of the operation. (%NOTIFY_OK, %NOTIFY_BAD)
  */
-static int __cpuinit relay_hotcpu_callback(struct notifier_block *nb,
+static int relay_hotcpu_callback(struct notifier_block *nb,
                                unsigned long action,
                                void *hcpu)
 {
