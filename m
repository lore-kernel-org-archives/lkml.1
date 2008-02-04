Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYBDC51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYBDC51 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 21:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYBDC5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 21:57:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:10892 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbYBDC5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 21:57:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NfZl1qDAH9gvARRvUvbhHnEo5HX1B2/i+oGvevNLkoQWXwWKvGHfA7hybWQdz4nTJCfQ4zcrF0ygqnIKAZHWXSF1v8Og+mQX/fTheBVDHSD9vGJis3tPePakwYh4zor+Z29hAOcFNj73HUvsop//m6AiBWygh77ETWYM9IW5Esc=
Message-ID: <804dabb00802031857l73a02b87jcad9cc2a89d19f81@mail.gmail.com>
Date: Mon, 4 Feb 2008 10:57:18 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Section mismatch: kernel/workqueue.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During compilation of the linus tree the following warnings are encountered:

WARNING: kernel/built-in.o(.data+0x2480): Section mismatch in
reference from the variable workqueue_cpu_callback_nb.14223 to the
function .devinit.text:workqueue_cpu_callback()
The variable workqueue_cpu_callback_nb.14223 references
the function __devinit workqueue_cpu_callback()
If the reference is valid then annotate the
variable with __init* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

This fix is to correct the following warning during compilation.
Based on my "elementary" analysis, as it is called from other
non-__init functions, this function cannot be declared as __devinit(),
correct?   Please comment.   Thanks :-).

Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>

--- workqueue.c.orig    2008-02-04 10:47:03.000000000 +0800
+++ workqueue.c 2008-02-04 10:45:49.000000000 +0800
@@ -825,7 +825,7 @@ void destroy_workqueue(struct workqueue_
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);

-static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
+static int workqueue_cpu_callback(struct notifier_block *nfb,
                                                unsigned long action,
                                                void *hcpu)
 {
