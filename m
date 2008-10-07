Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYJGHeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYJGHeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 03:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYJGHeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 03:34:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32911 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYJGHeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 03:34:14 -0400
Date: Tue, 7 Oct 2008 16:33:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "mingo@elte.hu" <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: mmotm 2008-10-02-16-17 uploaded
Message-Id: <20081007163331.711a938c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0810021705460.26309@shark.he.net>
References: <200810022318.m92NI14X031834@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0810021705460.26309@shark.he.net>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry if alread fixed.

Folloing function in git-x86.patch touches invalid address.
==
+void __init early_cpu_init(void)
+{
+       struct cpu_dev **cdev;
+       int count = 0;
+
+       printk("KERNEL supported cpus:\n");
+       for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
+               struct cpu_dev *cpudev = *cdev;
+               unsigned int j;
+
+               if (count >= X86_VENDOR_NUM)
+                       break;
+               cpu_devs[count] = cpudev;
+               count++;
+
+               for (j = 0; j < 2; j++) {
+                       if (!cpudev->c_ident[j])
+                               continue;
+                       printk("  %s %s\n", cpudev->c_vendor,
+                               cpudev->c_ident[j]);
+               }
+       }
+
+       early_identify_cpu(&boot_cpu_data);
 }
==
printk("  %s %s\n", cpudev->c_vendor, cpudev->c_ident[j]);
touches invalid address. (following is printk() result by
replacing %s with %p.
==
  ffffffff8066e38a ffffffff8066e383
  ffffffff8066e3ab ffffffff8066e3a2
  ffffffff8066e3af ffffffff8066e3b7
  807064c0c7c74855 08ec834853e58948
  807064c0c7c74855 74c085fffffe9fe8
==
and the kernel never boots on my box.

Thanks,
-Kame


