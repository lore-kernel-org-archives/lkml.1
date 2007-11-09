Return-Path: <linux-kernel-owner+w=401wt.eu-S1763629AbXKIVin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763629AbXKIVin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759218AbXKIVfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:35:22 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:64108 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761211AbXKIVfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:35:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=unah04j9CaVyNH/T9G/HfGDJGQbEtv2mrcK34WztjsPh3RZ9wZKGKybKolW7uFX+Cb6kp3+faepPJA755tyMvQyfVzNJloMEw50KnIhjjll2my/3Y/Y7lfU4Mff34p4yl7X0UekKXh8g/FaPwc7eW1Rc93wJiN8reHXTuDlEw4w=
Message-ID: <ef2af3100711091335y35c3d514u4faec75528fcec5b@mail.gmail.com>
Date: Fri, 9 Nov 2007 22:35:14 +0100
From: "Tobias Brox" <tobixen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: OOM killer problem - how to read the kernel log?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have a database server which we've had some problems with, we've
had some serious crashes (particularly during postgres vacuuming)
which couldn't be fixed without hardware reboot.  We assumed that the
problem would go away by itself after upgrading the server to a new
box with 32G of RAM ... but, alas, one of the first days in operation
it first killed lots of postgres children during the evening, and
finally it crashed and required hardware reboot.  The box is certainly
not out of memory, but after reading some posts here, I've understood
that memory management is a complex issue.

We're running 32 bits linux, maybe it would help to upgrade to 64 bits?

I'm pretty sure that everything we need to know is located in
/var/log/kernel.log - if we could only interpret it, that is.  I'm
particularly curious about those lines:

Nov  8 18:15:17 localhost kernel: DMA free:3556kB min:68kB low:84kB
high:100kB active:52kB inactive:0kB present:16256kB pages_scanned:208
all_unreclaimable? yes
Nov  8 18:15:17 localhost kernel: lowmem_reserve[]: 0 873 33512 33512
Nov  8 18:15:17 localhost kernel: Normal free:3676kB min:3744kB
low:4680kB high:5616kB active:892kB inactive:1792kB present:894080kB
pages_scanned:3468 all_unreclaimable? yes
Nov  8 18:15:17 localhost kernel: lowmem_reserve[]: 0 0 261112 261112
Nov  8 18:15:17 localhost kernel: HighMem free:7347404kB min:512kB
low:35536kB high:70560kB active:15982108kB inactive:9299956kB
present:33422336kB pages_scanned:0 all_unreclaimable? no
Nov  8 18:15:17 localhost kernel: lowmem_reserve[]: 0 0 0 0
Nov  8 18:15:17 localhost kernel: DMA: 7*4kB 15*8kB 5*16kB 0*32kB
0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3556kB
Nov  8 18:15:17 localhost kernel: Normal: 1*4kB 0*8kB 24*16kB 2*32kB
1*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3588kB
Nov  8 18:15:17 localhost kernel: HighMem: 2054*4kB 60332*8kB
54264*16kB 14863*32kB 4487*64kB 3716*128kB 1243*256kB 3228*512kB
80*1024kB 979*2048kB 169*4096kB = 7347608kB

I've copied out relevant files on
http://oppetid.no/~tobixen/oom_problem/ - it's the complete kernel
log, /proc/config.gz, /proc/slabinfo, /proc/meminfo and dmesg.  Those
are of course fetched after the reboot.

atop shows a relatively stable situation with plenty of free RAM and
caches all the evening.

(CCs preferred)
