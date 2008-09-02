Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYIBPn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYIBPn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 11:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYIBPnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 11:43:20 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:6679 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYIBPnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 11:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=LTjO4nMIkQQaotrspAZjZPNGKG0MEHK4LkiNXkGHdBbArWdAtaKWaFe9sgV29QiqSh
         HpKlA61TaJn0oBDI7dEOLfOqGwbBtBwHGLCL3J0NCCfF7HPDToUT/ij7veiL7LVwWYhJ
         2bw5Syvwj9fgmy6dcVNLIWuc+U9uIaNDKJcP4=
Message-ID: <b9df5fa10809020843h2d264062g894b5a719dca9091@mail.gmail.com>
Date: Tue, 2 Sep 2008 21:43:16 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: [PATCH] Fixing section mismatch warning .
Cc: linux-kernel@vger.kernel.org, marcin.slusarz@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   LD      kernel/built-in.o
WARNING: kernel/built-in.o(.text+0x326): Section mismatch in reference
from the function init_hrtick() to the variable
.cpuinit.data:hotplug_hrtick_nb.8
The function init_hrtick() references
the variable __cpuinitdata hotplug_hrtick_nb.8.
This is often because init_hrtick lacks a __cpuinitdata
annotation or the annotation of hotplug_hrtick_nb.8 is wrong.

 This patch fixes the above warning.
 Thanks.

Signed-off-by: Md.Rakib H. Mullick (rakib.mullick@gmail.com)

--- linux-2.6.27-rc5.orig/kernel/sched.c	2008-08-31 17:07:03.000000000 +0600
+++ linux-2.6.27-rc5/kernel/sched.c	2008-09-01 22:23:30.000000000 +0600
@@ -1087,7 +1087,7 @@ hotplug_hrtick(struct notifier_block *nf
 	return NOTIFY_DONE;
 }

-static void init_hrtick(void)
+static __init void init_hrtick(void)
 {
 	hotcpu_notifier(hotplug_hrtick, 0);
 }
