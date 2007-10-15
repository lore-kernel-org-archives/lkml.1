Return-Path: <linux-kernel-owner+w=401wt.eu-S1764231AbXJOWyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764231AbXJOWyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbXJOWyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:54:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:62570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbXJOWyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:54:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: asm-x86/* exported headers using CONFIG_X86_32
Date: Tue, 16 Oct 2007 00:53:58 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710160054.00138.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19M3+18T5fSkgs5evjGpUzNk3HQGFLc3JLNV1Q
 x6Vpvajh3bJvQTCoy8J1iUrCBSPRuP9zdR0YPJ2T5ch0J8/8Kc
 r4RsVQ5qIJ5SdggSSx5Rw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While looking through the new header files, I noticed lots of occurences
of #ifdef CONFIG_X86_32 in headers files exported for glibc.

This is fundamentally broken because user applications including them
do not know about any CONFIG_* symbols, and if they did, those
would incorrectly describe the ABI.

I guess in most cases, the headers that are interesting to user space
can simply be merged without any such #ifdef remaining, but those
that are still needed should be converted to use #ifdef __x86_64__,
which is set by the compiler.
This is how the other architectures avoid this particular problem.

	Arnd <><
