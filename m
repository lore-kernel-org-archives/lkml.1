Return-Path: <linux-kernel-owner+w=401wt.eu-S1760995AbYCYXJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995AbYCYXJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760723AbYCYXJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:09:10 -0400
Received: from relay2.mail.vrmd.de ([81.28.224.28]:47480 "EHLO
	relay2.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760700AbYCYXJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:09:08 -0400
X-Greylist: delayed 1722 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2008 19:09:07 EDT
Date: Tue, 25 Mar 2008 22:39:38 +0000
From: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
To: linux-kernel@vger.kernel.org
Subject: `.exit.text' referenced in section `.rodata'
Message-ID: <20080325223937.GA895@ds20.borg.net>
Reply-To: dl8bcu@dl8bcu.de
Mail-Followup-To: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
X-Relay-User: dl8bcu@dl8bcu.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello!

Current Kernels (2.6.25-rc6, commit d2532dd20a126020de407c1c2476a75b53fce7ac)
results in the following link errors:


  CC      arch/alpha/lib/udelay.o
  AR      arch/alpha/lib/lib.a
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: "saved_config" [vmlinux] is COMMON symbol
WARNING: modpost: Found 22 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
`.exit.text' referenced in section `.rodata' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2



Alpha ev6, gcc 4.1.2, everything built in.

With the following patch it builds and boots fine:


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5fe7aae..105e711 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1904,7 +1904,7 @@ err_out:
  *
  *	Note: this function unregisters this driver from the scsi mid-level.
  **/
-static void __exit exit_sd(void)
+static void exit_sd(void)
 {
 	int i;
 


Bye,
Thorsten

-- 
| Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
| Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
| Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |
