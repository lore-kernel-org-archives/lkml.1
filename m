Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYBYHob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYBYHob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 02:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYBYHoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 02:44:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:61062 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYBYHoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 02:44:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=JdnCuYOD7nQkUfTZvO/7SlaDn4ieiktBzqyih/Lky0wQInFWrK5ATEE8CUezxfDbl76MJyTCZgTelba7nxbNOEcloDr20Fn7gprU2uJnVeZPLT7Rw2LhBCpU8e/prm7uAs3PhUiTg2tNeK3qReqEo1CroZlSTOtITZB1doye6gE=
Message-ID: <2743ae110802242344s4406cd5eq3c5e8d0a6e69101b@mail.gmail.com>
Date: Mon, 25 Feb 2008 15:44:19 +0800
From: "Ady Wicaksono" <ady.wicaksono@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Patch kernel: I have 8 Gbytes RAM, but why I can only allocate 2.8 Gbytes RAM for a single process?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have 8 Gbytes RAM, but why I can allocate 2.8 Gbytes RAM for a single process?
How to patch kernel so I have more than 2.8 Gbytes limitation?

Kernel:
---------------------------
Linux xxx.com 2.6.9-023stab046.2-enterprise #1 SMP Mon Dec 10 15:22:33
MSK 2007 i686 i686 i386 GNU/Linux

Mem:
---------------------------
# cat /proc/meminfo
MemTotal:      8296484 kB
MemFree:         50416 kB
Buffers:         64412 kB
Cached:        4927328 kB
SwapCached:          0 kB
Active:        6710828 kB
Inactive:      1065384 kB
HighTotal:     4980736 kB
HighFree:         1024 kB
LowTotal:      3315748 kB
LowFree:         49392 kB
SwapTotal:    10256376 kB
SwapFree:     10255732 kB
Dirty:              64 kB
Writeback:           0 kB
Mapped:        3054960 kB
Slab:           393224 kB
CommitLimit:  14404616 kB
Committed_AS:  6318152 kB
PageTables:      34892 kB
VmallocTotal:   303096 kB
VmallocUsed:     22360 kB
VmallocChunk:   280496 kB


CPU (8 processor id from 0-7), one of them is:
---------------------------
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 6
model name      : Intel(R) Xeon(TM) CPU 3.00GHz
stepping        : 4
cpu MHz         : 2993.054
cache size      : 2048 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 6
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
lm constant_tsc pni monitor ds_cpl est cid xtpr
bogomips        : 5989.55

App to test memory limit:
---------------------------
#include <stdio.h>
#include <stdlib.h>

int main(){
        size_t siz = 100 * 1024 * 1024 ;
        size_t idx = 1 ;
        void *ptr;

        for (;;){
                ptr = malloc ( siz * idx );
                if(!ptr)
                        break ;
                free(ptr);
                idx++;
        }
        printf ("Max malloc %d * 100 MB \n", idx - 1 );
        return (0);
}

App result: Max malloc 28 * 100 MB ==> 2.8 Gbytes


-- 
Regards,

Ady Wicaksono
Email:
ady.wicaksono at gmail.com
http://adywicaksono.wordpress.com/
