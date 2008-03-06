Return-Path: <linux-kernel-owner+w=401wt.eu-S932491AbYCEXHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbYCEXHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932717AbYCEXBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:01:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:19899 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbYCEXBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:01:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=eFIPvNr4TV80G1EcPmfMEhmMp+nboa9/Bx1Rh7vRZldfy6TwbkgxCdVwcgw/8KByCD/aDElQXQmcu8knreEiMtivtOVnryIS9DoK28XGDfmDjaX3KQDgcSt4JWR98LUAgNhLyjNTitG5kY63NjlNEJeAFlG++BtCIcCOmc4u8gk=
From: Pawel Plociennik <paplociennik@gmail.com>
To: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.24] chroot= as a new kernel parameter
Date: Thu, 6 Mar 2008 00:01:38 -0500
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200803060001.38432.paplociennik@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m25N8Ynq010646

Hi Andrew and other *real* hackers,
I have sent a *last* version of a patch which it has added a new kernel parameter chroot=It were discusioned a *long time* on a lkml so I hope that it will has been applied.
Thanks,Pawel 
Acked-by: Pavel Machek <pavel@suse.cz>Signed-off-by: Pawel Plociennik <paplociennik@gmail.com>
---diff -urp linux-2.6.24-orig/Documentation/kernel-parameters.txt linux-2.6.24/Documentation/kernel-parameters.txt--- linux-2.6.24-orig/Documentation/kernel-parameters.txt       2008-02-25 20:53:26.000000000 -0500+++ linux-2.6.24/Documentation/kernel-parameters.txt    2008-03-04 09:51:52.000000000 -0500@@ -381,6 +381,8 @@ and is between 256 and 4096 characters.                         Value can be changed at runtime via                                /selinux/checkreqprot.        +       chroot=         [KNL] change a root for init process.+        clock=          [BUGS=X86-32, HW] gettimeofday clocksource override.                        [Deprecated]                        Forces specified clocksource (if available) to be useddiff -urp linux-2.6.24-orig/init/main.c linux-2.6.24/init/main.c--- linux-2.6.24-orig/init/main.c       2008-03-01 12:58:37.000000000 -0500+++ linux-2.6.24/init/main.c    2008-03-05 15:08:20.000000000 -0500@@ -755,8 +755,20 @@ static void __init do_pre_smp_initcalls(                spawn_softlockup_task(); } +static void *chroot_str;+static int __init chroot_setup(char *str)+{+       chroot_str = str;+       return 1;+}+__setup("chroot=", chroot_setup);+ static void run_init_process(char *init_filename) {+       if (chroot_str)+               if (sys_chroot(chroot_str) < 0)+                       panic("chroot=%s failed\n", chroot_str);+        argv_init[0] = init_filename;        kernel_execve(init_filename, argv_init, envp_init); }ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
