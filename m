Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbXBZQ2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbXBZQ2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXBZQ2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:28:21 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:46774 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbXBZQ2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:28:20 -0500
Message-ID: <45E30AB3.5050406@gmail.com>
Date: Mon, 26 Feb 2007 17:28:35 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Uwe Bugla <uwe.bugla@gmx.de>,
       akpm@linux-foundation.org, bunk@stusta.de, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@hpl.hp.com>, Andi Kleen <ak@suse.de>
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
 be mounted without hanging up the whole system
References: <20070224175424.176030@gmx.net> <45E2B88B.1090706@gmail.com> <45E2F8C5.3080905@gmail.com> <Pine.LNX.4.64.0702260741040.12485@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702260741040.12485@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds napsal(a):
> 
> On Mon, 26 Feb 2007, Jiri Slaby wrote:
>> Ok, this commit is the culprit:
>> Commit: 2ff2d3d74705d34ab71b21f54634fcf50d57bdd5
>> Author: Stephane Eranian <eranian@hpl.hp.com> Tue, 13 Feb 2007 13:26:22 +0100
>>
>>     [PATCH] i386: add idle notifier
> 
> Interesting. It doesn't touch floppy at all, but it *does* seem to play 
> around with irq state. 
> 
> In particular, the floppy uses IRQF_DISABLED (which means that it doesn't 
> want interrupts enabled when in the irq handler), and I get the feeling 
> that the poll_idle() stuff made that not work.

$ grep flags /proc/cpuinfo
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr

i.e. 'ht' and no 'monitor'; both poll_idle and mwait_idle are not involved, 
default_idle is.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
