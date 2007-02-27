Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbXB0MYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbXB0MYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 07:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXB0MYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 07:24:07 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:57558 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbXB0MYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 07:24:05 -0500
Date: Tue, 27 Feb 2007 21:24:21 +0900 (JST)
Message-Id: <20070227.212421.60652946.yoshfuji@linux-ipv6.org>
To: linux-kernel@vger.kernel.org
Cc: yoshfuji@linux-ipv6.org
Subject: 2.6.21-rc1-git compilation error in arch/i386/kernel/io_apic.c
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I got this error with current git tree with CONFIG_SMP=n.

|  CHK     include/linux/compile.h
|  CC      arch/i386/kernel/io_apic.o
|arch/i386/kernel/io_apic.c: In function `setup_IO_APIC_irqs':
|arch/i386/kernel/io_apic.c:1357: error: structure has no member named `affinity'
|arch/i386/kernel/io_apic.c: In function `io_apic_set_pci_routing':
|arch/i386/kernel/io_apic.c:2878: error: structure has no member named `affinity'
|make[1]: *** [arch/i386/kernel/io_apic.o] Error 1
|make: *** [arch/i386/kernel] Error 2

The commit 9f0a5ba5508143731dc63235de19659be20d26dc introduced
this issue.

The affinity member is only available with CONFIG_SMP.

Regards,

-- 
YOSHIFUJI Hideaki @ USAGI Project  <yoshfuji@linux-ipv6.org>
GPG-FP  : 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
