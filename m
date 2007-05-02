Return-Path: <linux-kernel-owner+w=401wt.eu-S2993374AbXEBPhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993374AbXEBPhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993381AbXEBPhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:37:03 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:11909 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993374AbXEBPhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mes2Sn7jGfnlMoG8sFe5WtNMdBpjySf8smUCvvm0ivtQtFu/U5wnsWTvpG8IEP9W8Oh6hJEXkXXXeezuUMR6nr4U/LV0HZhJ2yBaVA99EuTcROPkpPfX9+hK4NTFydWfJCZr5NnD9lveNHIOm8hnRyAcJgwiXoe5SPW+NebGWbM=
Message-ID: <547a31ab0705020836g1919a9b5sbd1747181aca82d2@mail.gmail.com>
Date: Wed, 2 May 2007 17:36:59 +0200
From: "Croulder Croulder" <croulder@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at mm/rmap.c:596!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


My servers are running 2.6.21 (oficial source code) since today and i
can see an error in syslog :



May  2 16:41:27 zz11 kernel: kernel BUG at mm/rmap.c:596!
May  2 16:41:27 zz11 kernel: invalid opcode: 0000 [#1]
May  2 16:41:27 zz11 kernel: SMP
May  2 16:41:27 zz11 kernel: Modules linked in:
May  2 16:41:27 zz11 kernel: CPU:    2May  2 16:41:27 zz11 kernel: CPU:    2
May  2 16:41:27 zz11 kernel: EIP:    0060:[<c0144e85>]    Not tainted VLI
May  2 16:41:27 zz11 kernel: EFLAGS: 00010246   (2.6.21.1-dh1 #7)
May  2 16:41:27 zz11 kernel: EIP is at page_remove_rmap+0xce/0xed
May  2 16:41:27 zz11 kernel: eax: 00000000   ebx: c1052b40   ecx:
c0560f70   edx: 00000082
May  2 16:41:27 zz11 kernel: esi: f7270764   edi: 00000020   ebp:
c7594378   esp: eafc3df8
May  2 16:41:27 zz11 kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
May  2 16:41:27 zz11 kernel: Process Mailscanner (pid: 5909,
ti=eafc2000 task=eed33570 task.ti=eafc2000)
May  2 16:41:27 zz11 kernel: Stack: c04dceab f7728a18 c1052b40
08cde000 c013fb98 00000000 f7270764 eafc3e70
May  2 16:41:27 zz11 kernel:        00000000 00000001 09000000
c4f8008c f52ac900 c18160e0 ffffff6a ffffffff
May  2 16:41:27 zz11 kernel:        c10eb28c c4f8008c 00369000
09d93000 00000000 eafc3e70 f43cd4c4 f52ac900
May  2 16:41:27 zz11 kernel: Call Trace:





How can i solve it? is it a documented bug?




Hardware details:
# free -m
             total       used       free     shared    buffers     cached
Mem:          1009        956         52          0         98        396
-/+ buffers/cache:        462        547
Swap:            0          0          0



/proc/cpuinfo  (4  Xeon procesor )

vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 2.80GHz
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid
xtpr
bogomips        : 5600.87


Filesystems:  ext3 and reiserfs ( 3.x)



ALL BUG message:


May  2 16:41:27 zz11 kernel: Eeek! page_mapcount(page) went negative! (-1)
May  2 16:41:27 zz11 kernel:   page pfn = 295a
May  2 16:41:27 zz11 kernel:   page->flags = 40000834
May  2 16:41:27 zz11 kernel:   page->count = 2
May  2 16:41:27 zz11 kernel:   page->mapping = f7728a18
May  2 16:41:27 zz11 kernel:   vma->vm_ops = _stext+0x3fefff40/0x14
May  2 16:41:27 zz11 kernel: ------------[ cut here ]------------
May  2 16:41:27 zz11 kernel: kernel BUG at mm/rmap.c:596!
May  2 16:41:27 zz11 kernel: invalid opcode: 0000 [#1]
May  2 16:41:27 zz11 kernel: SMP
May  2 16:41:27 zz11 kernel: Modules linked in:
May  2 16:41:27 zz11 kernel: CPU:    2
May  2 16:41:27 zz11 kernel: EIP:    0060:[<c0144e85>]    Not tainted VLI
May  2 16:41:27 zz11 kernel: EFLAGS: 00010246   (2.6.21.1-dh1 #7)
May  2 16:41:27 zz11 kernel: EIP is at page_remove_rmap+0xce/0xed
May  2 16:41:27 zz11 kernel: eax: 00000000   ebx: c1052b40   ecx:
c0560f70   edx: 00000082
May  2 16:41:27 zz11 kernel: esi: f7270764   edi: 00000020   ebp:
c7594378   esp: eafc3df8
May  2 16:41:27 zz11 kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
May  2 16:41:27 zz11 kernel: Process Postfix (pid: 5909, ti=eafc2000
task=eed33570 task.ti=eafc2000)
May  2 16:41:27 zz11 kernel: Stack: c04dceab f7728a18 c1052b40
08cde000 c013fb98 00000000 f7270764 eafc3e70
May  2 16:41:27 zz11 kernel:        00000000 00000001 09000000
c4f8008c f52ac900 c18160e0 ffffff6a ffffffff
May  2 16:41:27 zz11 kernel:        c10eb28c c4f8008c 00369000
09d93000 00000000 eafc3e70 f43cd4c4 f52ac900
May  2 16:41:27 zz11 kernel: Call Trace:
May  2 16:41:27 zz11 kernel:  [<c013fb98>] unmap_vmas+0x25d/0x4a9
May  2 16:41:27 zz11 kernel:  [<c014255a>] exit_mmap+0x75/0xe1
May  2 16:41:27 zz11 kernel:  [<c01161e9>] mmput+0x20/0x75
May  2 16:41:27 zz11 kernel:  [<c011a64f>] do_exit+0x1a1/0x693
May  2 16:41:27 zz11 kernel:  [<c011abad>] sys_exit_group+0x0/0xd
May  2 16:41:27 zz11 kernel:  [<c0121973>] get_signal_to_deliver+0x366/0x389
May  2 16:41:27 zz11 kernel:  [<c0110bde>] do_page_fault+0x0/0x512
May  2 16:41:27 zz11 kernel:  [<c0101ccd>] do_notify_resume+0x84/0x5c9
May  2 16:41:27 zz11 kernel:  [<c01409d4>] __handle_mm_fault+0x754/0x7a4
May  2 16:41:27 zz11 kernel:  [<c011eb25>] run_timer_softirq+0x36/0x15b
May  2 16:41:27 zz11 kernel:  [<c01110e6>] do_page_fault+0x508/0x512
May  2 16:41:27 zz11 kernel:  [<c0110bde>] do_page_fault+0x0/0x512
May  2 16:41:27 zz11 kernel:  [<c0102606>] work_notifysig+0x13/0x19
May  2 16:41:27 zz11 kernel:  [<c0450000>] one_sock_name+0x67/0xa3
May  2 16:41:27 zz11 kernel:  =======================
May  2 16:41:27 zz11 kernel: Code: c0 74 0d 8b 50 08 b8 db ce 4d c0 e8
e7 cd fe ff 8b 46 48 85 c0 74 14 8b 40 10 85 c0 74 0d 8b 50 2c b8 fa
ce
 4d c0 e8 cc cd fe ff <0f> 0b eb fe 8b 53 10 89 d8 59 5b 5b 5e 83 e2
01 f7 da 83 c2 04
May  2 16:41:27 zz11 kernel: EIP: [<c0144e85>]
page_remove_rmap+0xce/0xed SS:ESP 0068:eafc3df8
May  2 16:41:27 zz11 kernel: Fixing recursive fault but reboot is needed!
