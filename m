Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbXEUHiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbXEUHiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbXEUHiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:38:09 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:45458 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955AbXEUHiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:38:07 -0400
Message-ID: <46514C59.4020207@linux-kernel.at>
Date: Mon, 21 May 2007 09:38:01 +0200
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070419 Fedora/2.0.0.0-1.fc7 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] Missing defines in asm-alpha/unistd.h!?
References: <464AC75D.1090701@linux-kernel.at> <464AD1DB.3050609@linux-kernel.at> <464AE8D1.5000500@linux-kernel.at> <464B02BC.1040101@linux-kernel.at> <464B1275.6020007@linux-kernel.at> <20070516193852.GA10227@osiris.ibm.com>
In-Reply-To: <20070516193852.GA10227@osiris.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
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

On 05/16/2007 09:38 PM, Heiko Carstens wrote:
>>>> arch/alpha/kernel/built-in.o:(.data+0x2d60): undefined reference to
>>>> `sys_pselect6'
>>>> arch/alpha/kernel/built-in.o:(.data+0x2d68): undefined reference to
>>>> `sys_ppoll'
>>>> I don't understand this... Any clue(s)?
>>> Needed to replace sys_pselect6 and sys_ppoll with alpha_ni_syscall... If
>>> this is very correct way to fix it!? :-/
>>>
>>> Can someone please have a look and correct me!?
>> Sergey just told me, that this is wrong. Patch is fine, but we need
>> another. Please apply as well.
>>
>> --- linux-2.6.21.alpha/include/asm-alpha/thread_info.h.alpha_thread	2007-05-16 16:08:18.000000000 +0200
>> +++ linux-2.6.21.alpha/include/asm-alpha/thread_info.h	2007-05-16 16:08:07.000000000 +0200
>> @@ -76,12 +76,14 @@
>>  #define TIF_UAC_NOFIX		7
>>  #define TIF_UAC_SIGBUS		8
>>  #define TIF_MEMDIE		9
>> +#define TIF_RESTORE_SIGMASK	11
>>
>>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
>>  #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
>>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>> +#define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
> 
> If you want to wire up pselect6 and ppoll you need to add full
> TIF_RESTORE_SIGMASK support. With your patches it compiles but is broken.
> Search the git commits for "TIF_RESTORE_MASK" and see how this was
> implemented on other architectures.
> Also you should put the alpha maintainers on cc when sending such patches.

Thx Heiko. Yes. I already saw that problem. I will add a new patch... I
was out of country the last days - I wanted to do it last week, but ...
LONG story... :-/

- -of
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGUUxZxWN5Ge8lKUMRAoXmAJ94Wj6N0Ti6Owdg7LLgUdqDpJPonQCeP1iM
8MaYwjwuytEsjPyiU5/emF8=
=lrSg
-----END PGP SIGNATURE-----
