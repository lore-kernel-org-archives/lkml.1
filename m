Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZFXFEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZFXFEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 01:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZFXFDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 01:03:52 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:53691
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751131AbZFXFDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 01:03:51 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz328cM98dR14ffO13bfKzz1202hzzz2fh6bh17ch61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <4A41B3A5.9010807@am.sony.com>
Date: Tue, 23 Jun 2009 22:03:33 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Johnny Hung <johnny.hacking@gmail.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-embedded@vger.kernel.org
Subject: Re: How the kernel printk works before do console_setup.
References: <cb9ecdfa0906232050n6fcfee31ubeee4bcd9b8c0dfe@mail.gmail.com>
In-Reply-To: <cb9ecdfa0906232050n6fcfee31ubeee4bcd9b8c0dfe@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2009 05:03:34.0585 (UTC) FILETIME=[2044DA90:01C9F489]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johnny Hung wrote:
> Hi All:
>     I have a powerpc arch platform. The default console is ttyS1 not
> ttyS0 in the platform. My question is how the kernel print debug
> message
> like DBG before parse kernel command line and do console_setup
> function. The command line passed to kernel about console info is
> console=ttyS1.
> So kernel can not print anything before parse cmd line and initial
> console but the result is against. Anyone point me or give me a clue
> is appreciate.

Before the console is set up, the printk data is formatted
and put into the kernel log buffer, but not sent to any console.
Any messages printk'ed before that are buffered but do not
appear.  When the console is initialized, then all buffered
messages are sent to the console, and subsequent printks cause
the message to go to the log buffer, but then immediately
get sent from there to the console.

Under certain conditions you can examine the log buffer of
a kernel that failed to initialize it's console, after a
warm reset of the machine, using the firmware memory dump
command.

See http://elinux.org/Kernel_Debugging_Tips#Accessing_the_printk_buffer_after_a_silent_hang_on_boot
for some tips on accessing the log buffer of a previous boot.

Note also, that if the serial console does not come up,
but the kernel successfully boots, and you can get a network
login on the machine, you can always print out the kernel log
buffer messages using 'dmesg' at a user-space shell prompt.

Hope this helps!
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

