Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbXEPORg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbXEPORg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 10:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbXEPOR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 10:17:29 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:10782 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbXEPOR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 10:17:29 -0400
Message-ID: <464B1275.6020007@linux-kernel.at>
Date: Wed, 16 May 2007 16:17:25 +0200
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070419 Fedora/2.0.0.0-1.fc7 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] Missing defines in asm-alpha/unistd.h!?
References: <464AC75D.1090701@linux-kernel.at> <464AD1DB.3050609@linux-kernel.at> <464AE8D1.5000500@linux-kernel.at> <464B02BC.1040101@linux-kernel.at>
In-Reply-To: <464B02BC.1040101@linux-kernel.at>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------040200050908020107060801"
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-3.009, required 5, ALL_TRUSTED -1.80, BAYES_00 -2.60,
	PLING_QUERY 1.39)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040200050908020107060801
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/16/2007 03:10 PM, Oliver Falk wrote:
> On 05/16/2007 01:19 PM, Oliver Falk wrote:
>> On 05/16/2007 11:41 AM, Oliver Falk wrote:
>>> On 05/16/2007 10:57 AM, Oliver Falk wrote:
>>>> I believe this is missing... :-) I hope I understood NR_SYSCALLS
>>>> correctly and it's the number of defined syscals - as I added 20 of
>>>> them, I increased it by 20... Maybe someone can have a look if it's correct.
>>> [ ... ]
>>> Sorry, the patch was missing one hunk/file and also the tab stops where
>>> wrong. Attached a new working version.
>> But. The strange error that follows after patching:
>>   ld  -static -N  -o .tmp_vmlinux1 -T arch/alpha/kernel/vmlinux.lds
>> arch/alpha/kernel/head.o  init/built-in.o --start-group  usr/built-in.o
>>  arch/alpha/kernel/built-in.o  arch/alpha/mm/built-in.o
>> arch/alpha/math-emu/built-in.o  kernel/built-in.o  mm/built-in.o
>> fs/built-in.o  ipc/built-in.o  security/built-in.o  crypto/built-in.o
>> block/built-in.o  lib/lib.a  arch/alpha/lib/lib.a  lib/built-in.o
>> arch/alpha/lib/built-in.o  drivers/built-in.o  sound/built-in.o
>> net/built-in.o --end-group
>> arch/alpha/kernel/built-in.o:(.data+0x2d60): undefined reference to
>> `sys_pselect6'
>> arch/alpha/kernel/built-in.o:(.data+0x2d68): undefined reference to
>> `sys_ppoll'
> 
>> I don't understand this... Any clue(s)?
> 
> Needed to replace sys_pselect6 and sys_ppoll with alpha_ni_syscall... If
> this is very correct way to fix it!? :-/
> 
> Can someone please have a look and correct me!?

Sergey just told me, that this is wrong. Patch is fine, but we need
another. Please apply as well.

- -of
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGSxFcxWN5Ge8lKUMRApQjAJwOFDVvTLyU1iUnGPYZOjDsgdQc+gCgln/Z
/l4a0VXPlCgjTfzQXklaC1g=
=VFix
-----END PGP SIGNATURE-----

--------------040200050908020107060801
Content-Type: text/x-patch;
 name="linux-2.6.21-alpha_thread_info.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.21-alpha_thread_info.patch"

--- linux-2.6.21.alpha/include/asm-alpha/thread_info.h.alpha_thread	2007-05-16 16:08:18.000000000 +0200
+++ linux-2.6.21.alpha/include/asm-alpha/thread_info.h	2007-05-16 16:08:07.000000000 +0200
@@ -76,12 +76,14 @@
 #define TIF_UAC_NOFIX		7
 #define TIF_UAC_SIGBUS		8
 #define TIF_MEMDIE		9
+#define TIF_RESTORE_SIGMASK	11
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 
 /* Work to do on interrupt/exception return.  */
 #define _TIF_WORK_MASK		(_TIF_NOTIFY_RESUME	\

--------------040200050908020107060801--
