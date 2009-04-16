Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbZDPLCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbZDPLCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 07:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZDPLCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 07:02:34 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:54640
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946AbZDPLCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 07:02:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEmt5kl8qNw9/2dsb2JhbADQYoN9Bg
X-IronPort-AV: E=Sophos;i="4.40,198,1238947200"; 
   d="scan'208";a="468047455"
Message-ID: <49E71044.30801@eyal.emu.id.au>
Date: Thu, 16 Apr 2009 21:02:28 +1000
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Organization: Eyal at Home
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: list linux-kernel <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.30-rc2: undefined reference to `__udivdi3'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[a repeat, my first report failed to attract attention]

I get a build failure:

   LD      vmlinux.o
   MODPOST vmlinux.o
WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
   GEN     .version
   CHK     include/linux/compile.h
   UPD     include/linux/compile.h
   CC      init/version.o
   LD      init/built-in.o
   LD      .tmp_vmlinux1
arch/x86/mm/built-in.o(.init.text+0x178a): In function `memtest':
: undefined reference to `__udivdi3'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

I use
     gcc (GCC) 3.3.5 (Debian 1:3.3.5-13)

I know, very old Debian... but the doco says required version is 3.2.

A quick search indicates that this type of failure may be related to
gcc optimization (inlining?). I saw a similar report in linux-next recently.

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
