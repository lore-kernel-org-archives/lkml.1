Return-Path: <linux-kernel-owner+w=401wt.eu-S1030352AbXAZQp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030352AbXAZQp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030642AbXAZQp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:45:57 -0500
Received: from lmv.inov.pt ([146.193.64.2]:42303 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030352AbXAZQp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:45:56 -0500
X-Greylist: delayed 2890 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 11:45:55 EST
Message-ID: <45BA2341.40008@inov.pt>
Date: Fri, 26 Jan 2007 15:50:25 +0000
From: Jose Goncalves <jose.goncalves@inov.pt>
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Subject: Oops on serial access on kernel 2.6.16.38
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having a problem with the latest 2.6.16 kernel (I've found the
problem on 2.6.16.37 and 2.6.16.38). I have a application that retreives
data from a GPS connected on a serial port. From time to time a get a
kernel Oops, like this:

[15423.488491] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[15423.496682] printing eip:
[15423.504660] 00000000
[15423.504689] *pde = 00000000
[15423.512622] Oops: 0000 [#1]
[15423.520551] Modules linked in:
[15423.528445] CPU: 0
[15423.528461] EIP: 0060:[] Not tainted VLI
[15423.528477] EFLAGS: 00010202 (2.6.16.38-mtm4-debug #1)
[15423.553076] EIP is at rest_init+0x3feffdc0/0x1e
[15423.561877] eax: 00000060 ebx: 00000000 ecx: 00000000 edx: 000002fd
[15423.571312] esi: 00000000 edi: 00000040 ebp: 00000202 esp: c7613e4c
[15423.580941] ds: 007b es: 007b ss: 0068
[15423.590833] Process gp_position (pid: 4421, threadinfo=c7612000
task=c1240a90)
[15423.591608] Stack: c02fae70 00000005 c74304e0 c02fae70 c128d5e4
c7a69a80 c01ba49a c02fae70
[15423.613257] c128d5e4 00000000 c7a69a80 c7a69a80 c01bbaa0 c128d5e4
00000000 ffffffed
[15423.625736] c7a69a80 00000100 00400041 c01a9e67 c7627800 c7a69a80
01022e04 c7627800
[15423.638428] Call Trace:
[15423.650518] [] uart_startup+0x63/0xf4
[15423.663192] [] uart_open+0xaa/0xec
[15423.675954] [] tty_open+0x16c/0x270
[15423.688792] [] chrdev_open+0xd7/0xf0
[15423.701750] [] chrdev_open+0x0/0xf0
[15423.714647] [] __dentry_open+0xb4/0x180
[15423.727850] [] nameidata_to_filp+0x1f/0x31
[15423.741067] [] do_filp_open+0x37/0x3f
[15423.754480] [] strncpy_from_user+0x2e/0x4c
[15423.768075] [] get_unused_fd+0x4c/0x91
[15423.781757] [] do_sys_open+0x40/0xb5
[15423.795659] [] sys_open+0x13/0x17
[15423.809685] [] syscall_call+0x7/0xb
[15423.823902] Code: Bad EIP value.

Regards,
José Gonçalves

