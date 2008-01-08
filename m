Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbYAHCiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbYAHCiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 21:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbYAHCh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 21:37:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:14442 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbYAHCh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 21:37:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Bhhg2akSY34yXVdBMZlDQMxWXTZDR5hILl/kPjeIQzWHHTtLg69uPNk06zG5mT8A3yNyWu0n68ZAQYkhTW2vgdmCfoe4mHmHbmc3hckPuI0yO7d5yH/09acTnnK7hpwjORHH8vZtiK7l9DZ51ua4Zep53zL/dcmNEvN5wQeA7LI=
Message-ID: <86802c440801071837q1d6d63ewf095c9b497b33785@mail.gmail.com>
Date: Mon, 7 Jan 2008 18:37:56 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: kexec fail
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just found that when kexec 2.6.24-rc7 from RHEL 5.1 kernel got

Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
Bad page state in process 'swapper'
page:ffffe20004000018 flags:0x0000000000000000
mapping:0000000000000000 mapcount:1 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 0, comm: swapper Not tainted 2.6.24-rc7-smp #1

Call Trace:
 [<ffffffff80263fa3>] bad_page+0x63/0x8d
 [<ffffffff802640ed>] __free_pages_ok+0x7c/0x2a5
 [<ffffffff80ba7161>] free_all_bootmem_core+0xd0/0x198
 [<ffffffff80ba3a22>] numa_free_all_bootmem+0x3b/0x76
 [<ffffffff80ba30a2>] mem_init+0x4e/0x165
 [<ffffffff80b959dc>] start_kernel+0x236/0x2c2
 [<ffffffff80b95123>] _sinittext+0x123/0x12a

Bad page state in process 'swapper'
page:ffffe20004000050 flags:0x0000000000000000
mapping:0000000000000000 mapcount:1 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 0, comm: swapper Tainted: G    B   2.6.24-rc7-smp #1

Call Trace:
 [<ffffffff80263fa3>] bad_page+0x63/0x8d
 [<ffffffff802640ed>] __free_pages_ok+0x7c/0x2a5
 [<ffffffff80ba7161>] free_all_bootmem_core+0xd0/0x198
 [<ffffffff80ba3a22>] numa_free_all_bootmem+0x3b/0x76
 [<ffffffff80ba30a2>] mem_init+0x4e/0x165
 [<ffffffff80b959dc>] start_kernel+0x236/0x2c2
 [<ffffffff80b95123>] _sinittext+0x123/0x12a
...

somewhere from 64M

start_kernel
        ==> mem_init
                ==> numa_free_all_bootmem
                        ==> free_all_bootmem_node (NODE_DATA(i))
                                ==> free_all_bootmem_core ()
                                        ==> __free_pages_boot_mem
                                                ==> __free_pages(page, oder)
                                                        ==>
__free_pages_ok(page, order)
                                                                ==>
free_pages_check

 ==> bad_pages...


try to kexec 2.6.23 from RHEL 5.1, will get
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM ======> reboot

but 2.6.24-rc7 kexec 2.6.24-rc7 is ok.

YH
