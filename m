Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbXLSHVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbXLSHVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 02:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbXLSHVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 02:21:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:25763 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbXLSHVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 02:21:23 -0500
Message-ID: <4768C675.1030804@dev.mellanox.co.il>
Date: Wed, 19 Dec 2007 09:21:25 +0200
From: Dotan Barak <dotanb@dev.mellanox.co.il>
Reply-To: dotanb@dev.mellanox.co.il
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: dotanb@dev.mellanox.co.il
Subject: The code segment of the user level in PPC64 are in VMAs with write
 permissions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

I noticed that the code segment of the user level in PPC64 machines
is in a VMA with a write permission enabled.

I'm using the following machine attributes:
*************************************************************
Host Name         : mtlsqt185
Host Architecture : ppc64
Linux Distribution: SUSE Linux Enterprise Server 10 (ppc) VERSION = 10 
PATCHLEVEL = 1
Kernel Version    : 2.6.16.53-0.16-ppc64
GCC Version       : gcc (GCC) 4.1.2 20070115 (prerelease) (SUSE Linux)
Memory size       : 1740232 kB
Number of CPUs    : 8
cpu MHz           : 4005.000000MHz
Driver Version    : OFED-1.2.5.4-20071210-0614
HCA ID(s)         : mlx4_0
HCA model(s)      : 25418
FW version(s)     : 2.3.906
Board(s)          : IBM08A0000001
*************************************************************

I printed the address of a function in my program and i got the value 
0x1005ac80.

I printed the VMAs in my process and i got the following output:
mtlsqt185:~ # cat /proc/17366/maps
00100000-00103000 r-xp 00100000 00:00 0
10000000-1004a000 r-xp 00000000 08:03 1063667                            
/tmp/tsscr/svn.mlx_tp/branches/ofed1.2.5/gen2/userspace/useraccess/gen2_basic/gen2_basic 

1005a000-1005e000 rw-p 0004a000 08:03 1063667                            
/tmp/tsscr/svn.mlx_tp/branches/ofed1.2.5/gen2/userspace/useraccess/gen2_basic/gen2_basic 

1005e000-1015f000 rw-p 1005e000 00:00 0                                  
[heap]

Is this is a security hole (any virus can change the code in the code 
segment ...)

can you please CC me the answers o this question?


thanks
Dotan
