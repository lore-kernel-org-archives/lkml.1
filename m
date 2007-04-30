Return-Path: <linux-kernel-owner+w=401wt.eu-S1030811AbXD3KNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030811AbXD3KNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030852AbXD3KNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:13:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:45323 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030811AbXD3KNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:13:33 -0400
X-Authenticated: #4011369
X-Provags-ID: V01U2FsdGVkX1+XlqYM5uWXpnauNhwkKELV3pMabth4IWnDg05TdY
	b64W1NvypAdCdh
Subject: Re: Probable PCIE prob
From: Syren Baran <sbaran@gmx.de>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200704291521.48769.s0348365@sms.ed.ac.uk>
References: <1177790017.3649.23.camel@excalibur>
	 <200704291521.48769.s0348365@sms.ed.ac.uk>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 30 Apr 2007 12:13:31 +0200
Message-Id: <1177928011.3508.28.camel@excalibur>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 29.04.2007, 15:21 +0100 schrieb Alistair John Strachan:
> On Saturday 28 April 2007 20:53:37 Syren Baran wrote:
> > System crashes only happen when viewing films (neither
> > xine nor mplayer run with root privileges) and independent of video
> > drivers (framebuffer, vesa and fglrx). Logs dont show any anomalies
> > before crashing. Anybody got a clue?
> 
> This is a pretty bizarre crash. It might be a hardware problem. Try running a 
> load intensive task, something that heats your CPU up, for a long period. See 
> if it lasts longer than 30 minutes..

Think were getting in the right direction. Running "mencoder -ovc lavc
-oac lavc -of mpeg -o /dev/null somefilm" causes crashes consistantly
after a couple of minutes (using different kernels, some problem on XP).
Exchanging the CPU with an identical chip (Sempron 2800+, family 15,
model 79) caused the same behavior. On the other hand a highly
sophisticated, quick test for several hours (4-12, probably closer to
12) produced this crash:

EFLAGS: 00010093  (2.6.20-1.2944-fc6 #1)
EIP is at dump_trace+0x5c/0x93
eax: 75715ffd ebx: 75715f65 ecx: 0178d206 edx: 01236180
esi: 5f6f626f edi: 75715000 ebp: c06a645e esp: dead4d95
ds: 007b es: 007b ss:0068
Process a.out (pid 3499, ti=dead4000, task=eb64cbb0, task.ti=ea872000)
Stack: c06a645e c06a645e 00000018 00000000 c06a645e c0405001 c06fdc40
c06a645e
dead4f38 c04050b0 c06a645e c06a645e dead4e9d dead4ed5 00000002 00010046
dead4e9d dead4ed5 c0405246 c06a645e 00000010 eb64cd44 00000dab dead4000
Call Trace:
[<c0405001>] show_trace_log_lvl+0x18/0x2c
[<c04050b0>] show_trace_log_lvl+0x9b/0xa3
[<c0405246>] show_registers+018e/0x25d
[<c0621fcf>] notifier_call_chain+0x19/0x29
[<c0405443>] die+0x12e/0x240
[<c0621ee3>] do_page_fault+0x407/0x4da
[<c0621adc>] do_page_fault+0x0/0x4da
[<c0620744>] error_code+0x7c/0x84
BUG: unable to handle kernel paging request at virtual address 75715f65
printing eip:
c0404fb2
*pde=00000000
Recursive die() failure, output suppressed
<O>Kernel panic-not syncing: Fatal exception in interrupt

This is probable due to overheating (didnt have any thermal paste when
swapping the CPU´s). After waking up after 12 hours and noting the error
the CPU was still at 82 degrees celsius.
Unlike the crashes from mencoder, cpu temperatur below 40 degrees.
The only meaningfull error i could get when running mencoder (sometimes
system freezes, sometimes reboots, once got this message+freeze) "double
fault, gdt at c17c8000".


> Another thing you could try doing was eliminating X completely, by using 
> mplayer on a vesafb console..

Did the above tests in runlevel 3, thus eliminating X as a possible
cause. Also removed the gfx card to exclude electromagnetical
interference (onboard nv4 is sufficient).
Doesnt seem like a kernel bug, but (usermode-) mencoder causing a crash
on different kernels and OS´s is wierd.
> 

Syren

PS: the source code for the sophisticated a.out
int main(char *argv[], int argc){
        int i;
        while (1){
                i++;
        }
} 

