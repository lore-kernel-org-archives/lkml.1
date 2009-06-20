Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZFTM6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZFTM6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 08:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZFTM6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 08:58:39 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:51609 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZFTM6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 08:58:38 -0400
Message-ID: <4A3CDCFE.9080200@monstr.eu>
Date: Sat, 20 Jun 2009 14:58:38 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: adobriyan@gmail.com, Arnd Bergmann <arnd@arndb.de>,
       oberpar@linux.vnet.ibm.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>
Subject: [GIT PULL] arch/microblaze bug-fix for merge window (2.6.31)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

these two patches solve compilation build failures because
Alexey Dobriyan (bb1f17b0372de93758653ca3454bc0df18dc2e5c) forget to
remove init_mm from Microblaze kernel code.

and

Peter Oberparleiter (b99b87f70c7785ab1e253c6220f4b0b57ce3a7f7) add
constructor support
and Microblaze hadn't some exported symbols

Please add them asap.

Thanks,
Michal


The following changes since commit fb20871a54961b82d35303b43452928186c1361d:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/staging-2.6

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git for-linus

Arnd Bergmann (1):
      microblaze: remove init_mm

Michal Simek (1):
      microblaze: Add missing symbols for CONSTRUCTORS support

 arch/microblaze/kernel/init_task.c   |    2 --
 arch/microblaze/kernel/vmlinux.lds.S |   11 ++++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)


diff --git a/arch/microblaze/kernel/init_task.c
b/arch/microblaze/kernel/init_task.c
index 48eb9fb..67da225 100644
--- a/arch/microblaze/kernel/init_task.c
+++ b/arch/microblaze/kernel/init_task.c
@@ -18,8 +18,6 @@
 
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_SYMBOL(init_mm);
 
 union thread_union init_thread_union
        __attribute__((__section__(".data.init_task"))) =
diff --git a/arch/microblaze/kernel/vmlinux.lds.S
b/arch/microblaze/kernel/vmlinux.lds.S
index 8ae807a..d34d38d 100644
--- a/arch/microblaze/kernel/vmlinux.lds.S
+++ b/arch/microblaze/kernel/vmlinux.lds.S
@@ -62,7 +62,8 @@ SECTIONS {
 
        _sdata = . ;
        .data ALIGN (4096) : { /* page aligned when MMU used - origin 0x4 */
-               *(.data)
+               DATA_DATA
+               CONSTRUCTORS
        }
        . = ALIGN(32);
        .data.cacheline_aligned : { *(.data.cacheline_aligned) }
@@ -98,13 +99,13 @@ SECTIONS {
        . = ALIGN(4096);
        .init.text : {
                _sinittext = . ;
-               *(.init.text)
-               *(.exit.text)
-               *(.exit.data)
+               INIT_TEXT
                _einittext = .;
        }
 
-       .init.data : { *(.init.data) }
+       .init.data : {
+               INIT_DATA
+       }
 
        . = ALIGN(4);
        .init.ivt : {


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854

