Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbZCaUqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbZCaUqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZCaUqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:46:44 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:50771 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZCaUqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:46:43 -0400
Message-ID: <49D280EF.1080507@oracle.com>
Date: Tue, 31 Mar 2009 13:45:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Rusty Russell <rusty@rustcorp.com.au>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, andreas.herrmann3@amd.com
Subject: 2.6.29 boot hang
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.49D28113.0013:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(If this is old news, would someone please tell me the status
of this problem?  or if there is a known CPU issue, tell me.
Thanks.)



On a 4-proc x86_64 (HP BladeCenter, AMD CPUs) system, booting 2.6.29
(or earlier, back to 2.6.28-6921-g873392c) hangs during boot.

git bisect says:
873392ca514f87eae39f53b6944caf85b1a047cb is first bad commit
commit 873392ca514f87eae39f53b6944caf85b1a047cb
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Dec 31 23:54:56 2008 +1030

    PCI: work_on_cpu: use in drivers/pci/pci-driver.c
~~~~~~~~~~~~~~~~~~~~~

The last messages are usually like this:

Initializing CPU#1
Calibrating delay using timer specific routine.. 5224.09 BogoMIPS (lpj=10448183)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/0x2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU1: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
lockdep: fixing up alternatives.
Booting processor 2 APIC 0x1 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5224.12 BogoMIPS (lpj=10448242)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
lockdep: fixing up alternatives.
Booting processor 3 APIC 0x3 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5224.11 BogoMIPS (lpj=10448230)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)


If I change CONFIG_MICROCODE_AMD=y to CONFIG_MICROCODE_AMD=n & rebuild,
the kernel boots successfully.

There are never any kernel oops/panic/error messages.  I suppose that the
CPU microcode update (if there actually is one) causes some kind of
problem that prevents messages.


Suggestions, fixes, etc.??

Thanks,
-- 
~Randy
