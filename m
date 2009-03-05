Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZCEPgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZCEPgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZCEPgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:36:10 -0500
Received: from fifo99.com ([67.223.236.141]:44812 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbZCEPgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:36:09 -0500
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
From: Daniel Walker <dwalker@fifo99.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, stern@rowland.harvard.edu, randy.dunlap@oracle.com,
       ebiederm@xmission.com, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, sarah.a.sharp@intel.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-a1aade478862fca8710904532cbc6efed97fd05a@git.kernel.org>
References: <49AF18B7.4050305@kernel.org>
	 <tip-a1aade478862fca8710904532cbc6efed97fd05a@git.kernel.org>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 07:36:06 -0800
Message-Id: <1236267366.5937.56.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 10:00 +0000, Yinghai Lu wrote:

> +
> +Mini-HOWTO for using the earlyprintk=dbgp boot option with a
> +USB2 Debug port key and a debug cable, on x86 systems.
> +
> +You need two computers, the 'USB debug key' special gadget and
> +and two USB cables, connected like this:
> +
> +  [host/target] <-------> [USB debug key] <-------> [client/console]
> +
> +1. There are three specific hardware requirements:
> +
> + a.) Host/target system needs to have USB debug port capability.
> +
> + You can check this capability by looking at a 'Debug port' bit in
> + the lspci -vvv output:

...

> + c.) Thirdly, you need a second client/console system with a regular USB port.

You might want to combine a.) and c.) since there is some disconnect
between the two. c.) doesn't explicitly say a second time that the
client/console needs the debug port capability ..

Or say

a.) You will need two USB ports. One on the client/console system and
one one the target system.

b.) The client/console and target USB ports must have the debug port
capability. You can check for this as follows,

c.) ...

I just felt the disconnect between the two a.) , and c.) left some
questions.

> +2. Software requirements:
> +
> + a.) On the host/target system:
> +
> +    You need to enable the following kernel config option:
> +
> +      CONFIG_EARLY_PRINTK_DBGP=y
> +
> +    And you need to add the boot command line: "earlyprintk=dbgp".
> +    (If you are using Grub, append it to the 'kernel' line in
> +     /etc/grub.conf)

Isn't the usual grub.conf in /boot/grub/grub.conf ? That's where mine
always seem to end up.

> +    NOTE: normally earlyprintk console gets turned off once the
> +    regular console is alive - use "earlyprintk=dbgp,keep" to keep
> +    this channel open beyond early bootup. This can be useful for
> +    debugging crashes under Xorg, etc.
> +
> + b.) On the client/console system:
> +
> +    You should enable the following kernel config option:
> +
> +      CONFIG_USB_SERIAL_DEBUG=y
> +
> +    On the next bootup with the modified kernel you should
> +    get a /dev/ttyUSBx device(s).
> +
> +    Now this channel of kernel messages is ready to be used: start
> +    your favorite terminal emulator (minicom, etc.) and set
> +    it up to use /dev/ttyUSB0 - or use a raw 'cat /dev/ttyUSBx' to
> +    see the raw output.

You might want to switch the first /dev/ttyUSB0 to /dev/ttyUSBx .

> + c.) On Nvidia Southbridge based systems: the kernel will try to probe
> +     and find out which port has debug device connected.
> +
> +3. Testing that it works fine:
> +
> +   You can test the output by using earlyprintk=dbgp,keep and provoking
> +   kernel messages on the host/target system. You can provoke a harmless
> +   kernel message by for example doing:
> +
> +     echo h > /proc/sysrq-trigger
> +
> +   On the host/target system you should see this help line in "dmesg" output:
> +
> +     SysRq : HELP : loglevel(0-9) reBoot Crashdump terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) dump-ftrace-buffer(Z)
> +
> +   On the client/console system do:
> +
> +       cat /dev/ttyUSB0

Missing "x" here too.

Seems like a nice document. Thanks for writing it.

Daniel

