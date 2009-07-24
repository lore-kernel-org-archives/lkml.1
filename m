Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZGXTt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZGXTt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZGXTt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:49:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:45247 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754082AbZGXTt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:49:57 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19heJ973nFhqP3pme+fKxEu07AFrZa0lgbeVU1d/g
	XPcsfVq7TYk+cI
Message-ID: <4A6A1063.4050401@fisher-privat.net>
Date: Fri, 24 Jul 2009 21:49:55 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090710)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       greg@kroah.com
Subject: is ICQ10 broken by design? or there is some ehci vs uhci issue.
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo all,

i have some trouble with my Intel DG45ID (as usual). This one is long 
time issue and it too some time until i figured out the direction where 
should i search. I do not really understand how hardware work so i try 
to explain how i understand this problem.

The symptom is: if i connect some low speed uhci usb device to the usb 
port which has on same IRQ ehci and uhci buses.. this will crash other 
IRQ with uhci bus only.

Now, step by step:

i have usb sound card and if y plug it in and use it, after some time 
i'll get this message and my mouse will be painly slow:

[  315.056793] irq 16: nobody cared (try booting with the "irqpoll" option)
[  315.056799] Pid: 0, comm: swapper Not tainted
....
[  315.056878] Disabling IRQ #16

This is possible to reproduce with any low speed device.. but you need 
lot of traffic on it.


my mouse and keyboard was attached to the usb3 on IRQ 16 (the both are 
low speed devices)
  16:       4276       4520   IO-APIC-fasteoi   uhci_hcd:usb3

the sound card was attached to usb5 on IRQ 18 (this is low speed device too)
18:       2732       2598   IO-APIC-fasteoi   ehci_hcd:usb1, 
uhci_hcd:usb5,uhci_hcd:usb8

normally if i use usb3 (on IRQ 16) for hi speed it will be routed to 
ehci (IRQ 18) and if i use low speed it stay on IRQ 16. If use hi speed 
device on usb5 (IRQ 18) it will stay there because of ehci on IRQ 18. 
But if i use low speed device on usb5 (IRQ 18) this will route to IRQ 18 
and 16 ... 0_0 ... untill IRQ 16 will die. ...  i didn't so saw this on 
ich7 ...

Is it possible to fix it by software? i can't reproduce it with 
Windows... but i can't  monitore interrupts on separate devices there.

For more detail see:
http://bugzilla.kernel.org/show_bug.cgi?id=13816

regards,
Alexey


