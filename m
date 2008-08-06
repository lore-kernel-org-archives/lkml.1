Return-Path: <linux-kernel-owner+w=401wt.eu-S1763776AbYHFDPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763776AbYHFDPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYHFDPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:15:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:47334 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYHFDPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:15:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=kqXInbz5uQLW0KZgz30CG+oZtUGVVDLgrIfnzFX1jGF12+l/lllc39s/lcodasgN/P
         5lAxcob6/G5ZqRa5l/cLNxNAGjgZrdcFU7IZsptQOk8GikDfzRGtxLMCeXl8c6wV6Tfi
         X0ExpueuYMCAoRD6oB/eq6mOHb5+bEncvHlWA=
Message-ID: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
Date: Wed, 6 Aug 2008 11:15:30 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: 2.6.27rc1 cannot boot more than 8CPUs
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've a Dell R900 with 4 quad-core Xeon processors (total 16CPUs), but
can only managed to boot up with CONFIG_NR_CPUS=8. Setting
CONFIG_NR_CPUS=16 causes the kernel to hang while booting.


Here's the dmesg with CONFIG_NR_CPUS=8 ...

CPU6: Intel(R) Xeon(R) CPU           L7345  @ 1.86GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#6]: passed.
CPU 7 irqstacks, hard=c0526000 soft=c051e000
Booting processor 7/26 ip 6000
Initializing CPU#7
Calibrating delay using timer specific routine.. 3723.85 BogoMIPS (lpj=7447700)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 6
CPU: Processor Core ID: 2
x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
CPU7: Intel(R) Xeon(R) CPU           L7345  @ 1.86GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#7]: passed.
Brought up 8 CPUs
Total of 8 processors activated (29790.71 BogoMIPS).
net_namespace: 596 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16


Here's the dmesg with CONFIG_NR_CPUS=16 ...
Booting processor 8/1 ip 6000
Initializing CPU#8
Calibrating delay using timer specific routine.. 3723.85 BogoMIPS (lpj=7447793)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
CPU8: Intel(R) Xeon(R) CPU           L7345  @ 1.86GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#8]: passed.
*** Hangs here ***


How can I debug this further? I'm using the latest linux git pull.


Thanks,
Jeff.
