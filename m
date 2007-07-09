Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbXGIO2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbXGIO2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXGIO2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:28:05 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:17920 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXGIO2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:28:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=XT3hGMGFihthIu+zZNtoT97/mDDGKUqg/DAzoSfL2VmBn3crZ/ng3x3I6/VE2QnJvDYg86ZDqGaodNY0QTS3gv/Poi/vZCjhAPZ98qRrNlxy5LLOv3oP1zFGoP8z1C6ixQ1ifAYCaBYRTwmLY5OKVmNbZozW1OeEY1SzDy5V4Es=
Message-ID: <5a4c581d0707090727q15eff62ax1fdb1271754cc2d2@mail.gmail.com>
Date: Mon, 9 Jul 2007 16:27:59 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: clocksource change of behavior in 2.6.22 compared to 2.6.20 causes massive system clock slowdown
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My oldish AMD K7-800's clock began falling behind after
 rebooting from 2.6.20 (and 109 days uptime with a spotless
 clock) into 2.6.22; time lost is about four minutes each hour.

Turns out that 2.6.22 marks my TSC as unstable and starts
 using PIT instead. Rebooting 2.6.22 with clocksource=tsc
 gets the original stable system time back.

Not sure whether this is supposed to be the default way of
 fixing the issue on older machines, though; if anyone sees
 a problem with this, I'm up for providing more information.

[root@donkey ~]# cd /sys/devices/system/clocksource/clocksource0/
[root@donkey clocksource0]# cat available_clocksource
pit jiffies tsc
[root@donkey clocksource0]# cat current_clocksource
tsc
[root@donkey clocksource0]# uname -a
Linux donkey 2.6.22 #1 PREEMPT Mon Jul 9 13:26:38 CEST 2007 i686
athlon i386 GNU/Linux
[root@donkey clocksource0]# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 4
model name      : AMD Athlon(tm) Processor
stepping        : 2
cpu MHz         : 800.068
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
cmov pat pse36 mmx fxsr syscall mmxext 3dnowext 3dnow
bogomips        : 1603.17
clflush size    : 32


thanks, ciao,

--alessandro

 "Did you get married but forgot to get divorced ?"

     (Danny and Dusty, 'The Good Old Days')
