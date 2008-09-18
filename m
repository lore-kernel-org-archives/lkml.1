Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbYIRMy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbYIRMy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 08:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYIRMyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 08:54:49 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:58960 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbYIRMyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 08:54:49 -0400
X-Greylist: delayed 1715 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2008 08:54:48 EDT
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Subject: doubled idle count
Date: Thu, 18 Sep 2008 14:26:11 +0200
Message-ID: <87vdwtfxng.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After upgrading a Xen virtual machine to Debian's 2.6.26-4 kernel, I
noticed that the idle counter doubled its pace on one of the machines:

service2:~# yes >/dev/null &
[1] 32578
service2:~# grep cpu0 /proc/stat; sleep 1; grep cpu0 /proc/stat
cpu0 141208 9113 57273 13379659 61012 0 792 2350 0
cpu0 141310 9113 57274 13379659 61012 0 792 2350 0
service2:~# fg
yes > /dev/null
^C
service2:~# grep cpu0 /proc/stat; sleep 1; grep cpu0 /proc/stat
cpu0 141952 9113 57277 13383481 61012 0 792 2350 0
cpu0 141953 9113 57278 13383681 61012 0 792 2350 0

One out of three machines show this effect, with the exact same kernel
and Xen versions (3.2.0, dom0 is Debian's stock Etch 2.6.18 kernel).
They aren't hosted by the same machine, though: the misbehaving one is
on a different installation with very similar hardware (3 vs 2 GHz).
All the guest are paravirtual.

service2:~# cat /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Xeon(TM) CPU 3.06GHz
stepping	: 5
cpu MHz		: 3056.482
cache size	: 1024 KB
physical id	: 0
siblings	: 1
core id		: 0
cpu cores	: 1
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu de tsc msr pae cx8 cmov pat pse36 clflush dts mmx fxsr sse sse2 ss ht pbe up pebs bts cid xtpr
bogomips	: 6128.11
clflush size	: 64
power management:

I don't know what else would be useful, please ask.
-- 
Thanks,
Feri.
