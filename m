Return-Path: <linux-kernel-owner+w=401wt.eu-S1751255AbXBZPLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbXBZPLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030250AbXBZPLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:11:50 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:45869 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbXBZPLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:11:49 -0500
Message-ID: <45E2F8C5.3080905@gmail.com>
Date: Mon, 26 Feb 2007 16:12:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Uwe Bugla <uwe.bugla@gmx.de>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, bunk@stusta.de, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@hpl.hp.com>, Andi Kleen <ak@suse.de>
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
 be mounted without hanging up the whole system
References: <20070224175424.176030@gmx.net> <45E2B88B.1090706@gmail.com>
In-Reply-To: <45E2B88B.1090706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
>> Once again and for the last time: I do not state that floppy.c is 
>> broken. I only state that it is immpossible to mount a floppy drive 
>> with kernel 2.6.21-rc1-git1. Kernel 2.6.20 is OK. But 2.6.21-rc1-git1 
>> is definitely buggy!
>> I did some work already:
>> a. I copied the following modules from the intact and sane kernel 
>> 2.6.20 into the 2.6.21-rc1-git1 tree:
>> cdrom.h, floppy.c, init.h, io.h, proc_misc.c, setup.c, timer.h, uaccess.h
>> b. I adjusted some hunks of the patch for module main.c (part of 
>> patch-2.6.21-rc1) to make the kernel compile without errors.
>> But the problem still persists, and I do not have any idea anymore 
>> where the offensive hunks in patch-2.6.21-rc1 could reside.
>>
>> Questions:
>> a. Can someone please confirm the described problem?
> 
> Yup (last -mm).

Ok, this commit is the culprit:
Commit: 2ff2d3d74705d34ab71b21f54634fcf50d57bdd5
Author: Stephane Eranian <eranian@hpl.hp.com> Tue, 13 Feb 2007 13:26:22 +0100

     [PATCH] i386: add idle notifier

     Add a notifier mechanism to the low level idle loop.  You can register a
     callback function which gets invoked on entry and exit from the low level id
     loop.  The low level idle loop is defined as the polling loop, low-power cal
     or the mwait instruction.  Interrupts processed by the idle thread are not
     considered part of the low level loop.

     The notifier can be used to measure precisely how much is spent in useless
     execution (or low power mode).  The perfmon subsystem uses it to turn on/off
     monitoring.

     Signed-off-by: stephane eranian <eranian@hpl.hp.com>
     Signed-off-by: Andrew Morton <akpm@osdl.org>
     Signed-off-by: Andi Kleen <ak@suse.de>

---

Reverting (some manual work due to irq.c changes) this on latest -mm allows me 
to mount floppy again.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
