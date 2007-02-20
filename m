Return-Path: <linux-kernel-owner+w=401wt.eu-S1030307AbXBTRaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307AbXBTRaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030327AbXBTRaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:30:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:58763 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030307AbXBTRaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:30:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ZOYVy5EecYaLBZRt2Ibv9BaNR3oexImatrD1a6eMpagVrL3sRJ4pcXGsc9zkjz4ybAmdOdDeOsl7sHsvjQJCtGYxzKS8kiWBJAMXhZkbuzRli1kBMbCMSm2FdoRgmIIceLT610kjn80xSs9uBdvmRzIZRXThwjj9d0mJZc+cseg=
Message-ID: <bc36a6210702200930n2d4b1f76m9fc5e5f0728f7b48@mail.gmail.com>
Date: Tue, 20 Feb 2007 10:30:21 -0700
From: "Andrew Robinson" <andrew.rw.robinson@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel oops in 2.6.18.3 with RAID5
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I can't seem to find sufficient information on what may have caused an
oops. I am running a debian machine using kernel 2.6.18.3. Here is
detailed information on the system:

debian etch
CPU: AMD athlon 2100+
kernel package: linux-image-2.6.18-3-686
raid5 array: 3 active, 1 spare on md0
raid fs: ext3
raid is physically across 2 on-board NVidia SATA ports and 2 ports
from a SATA controller card

I am at work, and this was a home computer. This is what I got from
syslog when in SSH before it died:

bserver kernel: iret exception: 0000 [#1]
bserver kernel: SMP
bserver kernel: CPU:    0
bserver kernel: EIP is at copy_data+0xff/0x14b [raid456]
bserver kernel: eax: ddcce000   ebx: 00001000   ecx: 0000000f   edx: c1f71000
bserver kernel: esi: ddccefc4   edi: c1f71fc4   ebp: 00000000   esp: dd261e4c
bserver kernel: ds: 007b   es: 007b   ss: 0068
bserver kernel: Process md0_raid5 (pid: 1115, ti=dd260000
task=dd0ed550 task.ti=dd260000)
bserver kernel: Stack: c1f71000 ddb55460 c1e377a0 00000000 ddcce000
00001000 c1f71000 00000000
bserver kernel:        00000000 00000000 00000000 dd20c388 c1e377a0
dd20c354 de95d96d 0c649510
bserver kernel:        00000000 c0116d0a 06323c4f 00000000 dd20c384
00000000 c13c52e0 0000e000
bserver kernel: Call Trace:
bserver kernel: Code: 8d 04 2f 01 4c 24 18 83 7c 24 0c 00 8b 54 24 18
8d 34 32 89 34 24 74 09 89 d9 89 c7 c1 e9 02 eb 0a 8b 3c 24 89 d9 89
c6 c1 e9 02 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 8b 44 24 18 ba 03 00 00
00 e8
bserver kernel: EIP: [<de95b0cb>] copy_data+0xff/0x14b [raid456]
SS:ESP 0068:dd261e4c

The only similar message chain that I could find was about 2.6.19 and
they recommended disabling preempting, but debian's 2.6.18.3 already
has that disabled by default.

Any ideas?

Thanks,
Andrew
