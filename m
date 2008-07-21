Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbYGUNOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbYGUNOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYGUNON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:14:13 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:45044 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbYGUNOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Xzi9Yq4UKnXLnyURjUNwO58tujstNNawL9fx4l93g/AI/HIqyBLtCp1j55ob2zJWF1
         U78IiBvXxQvvP7FqA1KHpoc++1D6+eKUJkq64EAXuseK1EM5BGrtpAeZlTSlbv7XpRTT
         lqqIL/XwX2T/zqb2vqQebQL9A8GH61lIW3K6E=
Message-ID: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>
Date: Mon, 21 Jul 2008 06:14:11 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "linux kernel" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>
Subject: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot boot
Cc: "Ivan Seskar" <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug seems to be present since 2.6.22 [1], so hope we can get this
fixed ASAP. Let me know if you have patch suggestions I can test.

This crashes very early, I had to use earlyprintk to get it.

BUG: Int 6: CR2 00000000
     EDI 00000000  ESI 0009f000  EBP 00000000  ESP c036ff60
     EBX c03e6070  EDX 00000006  ECX 0000009f  EAX c034d240
     err 00000000  EIP c0387ac2   CS 00000060  flg 00010016
Stack: 00000000 00000000 c03b63d8 c037bb11 0001dff0 00003c00 c0399614 c03b6304
       00822007 c037aeb4 c0304134 000001df c0304117 00000000 30303030 205d3030
       00000000 c034c794 00000000 00000000 00822007 c02b921f c034c794 00000000
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.26 #1
BUG: Int 6: CR2 00000000
     EDI 00000000  ESI c034c018  EBP 00000000  ESP c036feb8
     EBX c036ff28  EDX 00000006  ECX c03e6070  EAX c034c018
     err 00000000  EIP c013d922   CS 00000060  flg 00010016
Stack: c036ff28 c03e6070 c01305ef c0104a34 c036fffc c036e000 0009f000 00000002
       0009f000 00000000 00000000 c0105969 00000000 c02bee94 c0310de8 c02b9129
       00000000 c0303d6a 00000000 c034751d c03c7278 c0347faa 00000002 c0347feb
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.26 #1

node1-1:~# cat /proc/cpuinfo
processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 9
model name      : VIA Nehemiah
stepping        : 8
cpu MHz         : 997.108
cache size      : 64 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr cx8 sep mtrr pge cmov pat mmx
fxsr sse up rng rng_en ace ace_en
bogomips        : 1996.49
clflush size    : 32

You can get my config from:

http://www.winlab.rutgers.edu/~mcgrof/configs/config-2.6.26

It's basically debian based from 2.6.25-2 just updated for 2.6.26. Let
me know if I can provide more information.

[1] http://orbit-lab.org/wiki/Documentation/SupportedImages/baseline-8.3.ndz

  Luis
