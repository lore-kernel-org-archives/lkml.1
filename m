Return-Path: <linux-kernel-owner+w=401wt.eu-S1752480AbZJWXoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbZJWXoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZJWXoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:44:54 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:56324 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZJWXox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:44:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Xo6ZyMHprVuWsUDH0P/BFGwkQWDZAgRtWTcdc3Zeyweerxs3eq7Yr6KU8fsLNICFDj
         OX4OiNfVQV2JSJ/vINeAVcOsJKwl43BySWEJegevu4o+6YwBsrWXrlKNkH4+o9aytGL6
         poKFxpCUt8486AwBRpNul0IdHgf22vu8gRy7w=
Message-ID: <4AE24009.4090408@gmail.com>
Date: Fri, 23 Oct 2009 16:45:13 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking into seeing if kdump might be able to log this in, but 
after reading up
I realized that kdump is something that needs to be on then if a crash 
occurs,
  then kexec to the rescue.

Anyways I posted a picture on my facebook page of this, and also will 
send a post
manually writing this down.
Basically when I use ohci1394_dma=early on the boot param
this happens. if I don't use that boot option then the system runs fine.

[    0.000000] [<ffffffff81639995>] start_kernel+0x82/0x34d
[    0.000000] [<ffffffff816392a5>] x86_64_start_reservations+0xac/0xb0
[    0.000000] [<ffffffff816393a1>] x86_64_start_kernel+0xf8/0x107
PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
[    0.000000] Pid: 0, comm: swapper Not tainted 
2.6.32-rc4-00001-g1896a85 #35
[    0.000000] Call Trace:
[    0.000000] [<ffffffff8163919e>] early_idt_handler+0x5e/0x71
[    0.000000] [<ffffffff813b9958>] ? panic+0x10c/0x12e
[    0.000000] [<ffffffff8164f777>] ___alloc_bootmem_node+0x0/0x60
[    0.000000] [<ffffffff8164f8eb>] __alloc_bootmem+0xb/0xd
[    0.000000] [<ffffffff813aba66>] spp_getpage+0x3a/0x6f
[    0.000000] [<ffffffff8102770d>] fill_pte+0x22/0xde
[    0.000000] [<ffffffff810278e7>] set_pte_vaddr_pud+0x2c/0x48
[    0.000000] [<ffffffff81027963>] set_pte_vaddr+0x60/0x65
[    0.000000] [<ffffffff8102b82e>] __native_set_fixmap+0x24/0x2c
[    0.000000] [<ffffffff81660252>] 
init_ohci1394_dma_on_all_controllers+0x9b/0x345
[    0.000000] [<ffffffff8163be6b>] setup_arch+0x543/0x950
[    0.000000] [<ffffffff813b99b6>] ? printk+0x3c/0x3e
[    0.000000] [<ffffffff810646b6>] ? 
clockevents_register_notifier+0x3e/0x48
[    0.000000] [<ffffffff81639995>] start_kernel+0x82/0x34d
[    0.000000] [<ffffffff816392a5>] x86_64_start_reservations+0xac/0xb0
[    0.000000] [<ffffffff816393a1>] x86_64_start_kernel+0xf8/0x107
[    0.000000] RIP 0x10

The system is a LFS pure64 build on an imac,macbook(both systems the
same, and both crash like this).

Any ideas on this, and also any ideas on how I could try and grab a
syslog this early in the boot?

Justin P. Mattock


