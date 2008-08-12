Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYHLQKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYHLQKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 12:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbYHLQKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 12:10:47 -0400
Received: from pegasus.biostat.wisc.edu ([144.92.73.35]:58287 "EHLO
	pegasus.biostat.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYHLQKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 12:10:46 -0400
X-Greylist: delayed 1882 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2008 12:10:46 EDT
Message-ID: <48A1AEA4.5070004@biostat.wisc.edu>
Date: Tue, 12 Aug 2008 10:39:16 -0500
From: Beverly Seavey <seavey@biostat.wisc.edu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080515)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: fscanf changes value when reading .  cc version 4.1.2 20071124 (Red
 Hat 4.1.2-42)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BCG-MailScanner-Information: BCG: sysreq@biostat.wisc.edu
X-BCG-MailScanner: Found to be clean
X-BCG-MailScanner-From: seavey@biostat.wisc.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hornbill% 10:36>g++ -v
Using built-in specs.
Target: i386-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man 
--infodir=/usr/share/info --enable-shared --enable-threads=posix 
--enable-checking=release --with-system-zlib --enable-__cxa_atexit 
--disable-libunwind-exceptions --enable-libgcj-multifile 
--enable-languages=c,c++,objc,obj-c++,java,fortran,ada 
--enable-java-awt=gtk --disable-dssi --enable-plugin 
--with-java-home=/usr/lib/jvm/java-1.4.2-gcj-1.4.2.0/jre 
--with-cpu=generic --host=i386-redhat-linux
Thread model: posix
gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)
hornbill% 10:36>



(gdb) watch *(allLeavesUpperBounds + 12)
Hardware watchpoint 1: *(allLeavesUpperBounds + 12)
(gdb) run
Starting program: 
/v/v03/s/seavey/private/condStuff/apD14L14-S07-75751_S04-1616-100f-NF
Hardware watchpoint 1: *(allLeavesUpperBounds + 12)
Hardware watchpoint 1: *(allLeavesUpperBounds + 12)
Hardware watchpoint 1: *(allLeavesUpperBounds + 12)
Hardware watchpoint 1: *(allLeavesUpperBounds + 12)
Hardware watchpoint 1: *(allLeavesUpperBounds + 12)
Hardware watchpoint 1: *(allLeavesUpperBounds + 12)

Old value = 
0                                                                            
<<<<<<<<<<<<<<< this I did
New value = 1
0x00546231 in _IO_vfscanf_internal () from /lib/libc.so.6
(gdb) cont
Continuing.
Hardware watchpoint 1: *(allLeavesUpperBounds + 12)

Old value = 1
New value = 
0                                                                         
<<<<<<<<<<<<<<< fscanf did this
0x00546231 in _IO_vfscanf_internal () from /lib/libc.so.6
(gdb) where
#0  0x00546231 in _IO_vfscanf_internal () from /lib/libc.so.6
#1  0x00547b33 in vfscanf () from /lib/libc.so.6
#2  0x0054c612 in fscanf () from /lib/libc.so.6
#3  0x0804b7e2 in readCompiled (readParamsPtr=0x870f070, treeCtr=14, 
numLeaves=1, allTreesLowerBounds=0x804efa0, allTreesUpperBounds=0x8050bc0)
    at apD14L14-S07-75751_S04-1616-100f-NF.c:880
#4  0x0804c230 in main () at apD14L14-S07-75751_S04-1616-100f-NF.c:423
(gdb)

