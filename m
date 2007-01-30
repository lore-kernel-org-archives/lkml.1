Return-Path: <linux-kernel-owner+w=401wt.eu-S965114AbXA3MKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbXA3MKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 07:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965282AbXA3MKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 07:10:48 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:23839 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965114AbXA3MKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 07:10:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=J5zaFXgRnjSDdQF/spvgB3bSs6+M+1Gad1j+J2uV3+8lma06sI+ZplsrrGgY34RRAXcRWPrLPpls8lyMRznxyIfaamviU4Q/Q++YNa41Hkyze2D03IPTry7+6z1xiaF1ycIwKDXnAEmGrUZR/jrQHF6pDzU/lt3OlgTnpnphJHo=
Message-ID: <e9f486400701300410l479cde02jc916ccde81163f8c@mail.gmail.com>
Date: Tue, 30 Jan 2007 13:10:46 +0100
From: "Henri Hunnekens" <henrihunnekens@gmail.com>
Subject: [ OOPS ] at do_futex with 2.6.20-RC5-RT10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ingo,

I've an made an application which causes an OOPS using kernel version
2.6.20-RC5-RT10 ( also seen with older verison 2.6.19.1-rt15 ) + FC6
userland.

The application periodically calls the libc system() routine. The
system() routine just calls a simple external bash script. The
application is a SCHED_OTHER application with PI mutexes. I think that
the problem is caused by the system() routine.

The following is a dump of the stdout made with kernel version
2.6.19.1-rt15. But 2.6.20-RC5-RT10 has the same problem.


Oops: 0003 [#1]
PREEMPT SMP
Modules linked in: cap_over commoncap i2c_dev uhci_hcd i2c_i801 i2c_core ehci_hc
d
CPU:    0
EIP:    0060:[<c0141d9c>]    Not tainted VLI
EFLAGS: 00010246   (2.6.19.1-rt15 #1)
EIP is at do_futex+0x8ec/0xfb0
eax: 0000081f   ebx: 0000081f   ecx: 08511a28   edx: 00000000
esi: 8000081f   edi: dc3e7fa0   ebp: dc3e7f7c   esp: dc3e7e38
ds: 007b   es: 007b   ss: 0068   preempt: 00000002
Process SSL_Linux (pid: 2079, ti=dc3e6000 task=df6bd000 task.ti=dc3e6000)
Stack: dc3e7eac c05a6570 00000278 00000001 6e6a32ae 00000000 c05a74e0 00000000
       15c1f019 00000277 0000086f 00000000 c16ecaa0 04000001 c05a7360 00000000
       c16ecaa0 00000086 df6ad550 dc3e6000 00000000 fffffff2 c05a7de0 df6ad550
Call Trace:
 [<c01054e6>] show_trace_log_lvl+0x26/0x40
 [<c01055b1>] show_stack_log_lvl+0xb1/0xe0
 [<c01059ef>] show_registers+0x1cf/0x280
 [<c0105bdf>] die+0x13f/0x320
 [<c0119a7c>] do_page_fault+0x21c/0x660
 [<c04252e9>] error_code+0x39/0x40
 [<c01424ff>] sys_futex+0x9f/0xd0
 [<c01047ad>] sysenter_past_esp+0x56/0x79
 =======================
Code: 08 8b 9a b0 00 00 00 83 c1 04 19 d2 39 48 18 83 da 00 85 d2 b9 01 00 00 00
 c7 85 10 ff ff ff f2 ff ff ff 75 17 89 d8 8b 4d 08 90 <0f> b1 11 31 c9 83 f8 f2
 89 85 10 ff ff ff 0f 94 c1 89 e0 25 00

Do you have any idea what causes this problem or how to find out?

Best regards,
Henri Hunnekens
