Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbXEPNLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbXEPNLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXEPNKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:10:53 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:30027 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXEPNKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:10:52 -0400
Message-ID: <464B02BC.1040101@linux-kernel.at>
Date: Wed, 16 May 2007 15:10:20 +0200
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070419 Fedora/2.0.0.0-1.fc7 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, ac-admin@lists.anotherbloody.com
Subject: Re: [patch] Missing defines in asm-alpha/unistd.h!?
References: <464AC75D.1090701@linux-kernel.at> <464AD1DB.3050609@linux-kernel.at> <464AE8D1.5000500@linux-kernel.at>
In-Reply-To: <464AE8D1.5000500@linux-kernel.at>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-3.009, required 5, ALL_TRUSTED -1.80, BAYES_00 -2.60,
	PLING_QUERY 1.39)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/16/2007 01:19 PM, Oliver Falk wrote:
> On 05/16/2007 11:41 AM, Oliver Falk wrote:
>> On 05/16/2007 10:57 AM, Oliver Falk wrote:
>>> I believe this is missing... :-) I hope I understood NR_SYSCALLS
>>> correctly and it's the number of defined syscals - as I added 20 of
>>> them, I increased it by 20... Maybe someone can have a look if it's correct.
>> [ ... ]
> 
>> Sorry, the patch was missing one hunk/file and also the tab stops where
>> wrong. Attached a new working version.
> 
> But. The strange error that follows after patching:
>   ld  -static -N  -o .tmp_vmlinux1 -T arch/alpha/kernel/vmlinux.lds
> arch/alpha/kernel/head.o  init/built-in.o --start-group  usr/built-in.o
>  arch/alpha/kernel/built-in.o  arch/alpha/mm/built-in.o
> arch/alpha/math-emu/built-in.o  kernel/built-in.o  mm/built-in.o
> fs/built-in.o  ipc/built-in.o  security/built-in.o  crypto/built-in.o
> block/built-in.o  lib/lib.a  arch/alpha/lib/lib.a  lib/built-in.o
> arch/alpha/lib/built-in.o  drivers/built-in.o  sound/built-in.o
> net/built-in.o --end-group
> arch/alpha/kernel/built-in.o:(.data+0x2d60): undefined reference to
> `sys_pselect6'
> arch/alpha/kernel/built-in.o:(.data+0x2d68): undefined reference to
> `sys_ppoll'
> 
> I don't understand this... Any clue(s)?

Needed to replace sys_pselect6 and sys_ppoll with alpha_ni_syscall... If
this is very correct way to fix it!? :-/

Can someone please have a look and correct me!?

- -of
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGSwK8xWN5Ge8lKUMRAtlmAKCCnPVI/RwU8l7gLHXy3PdQcfh3FACgijin
V1vWFNgNB+7y6llUVqKzIis=
=+BlN
-----END PGP SIGNATURE-----
