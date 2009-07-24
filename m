Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbZGXDe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbZGXDe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZGXDe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:34:27 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33101 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbZGXDe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:34:26 -0400
Subject: Panic on IBMMCA SCSI driver with 2.6.30
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.orglanga2, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 20:34:24 -0700
Message-Id: <1248406465.24021.734.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, this isn't a joke.  I actually still have an IBM 9595, and I've been
running 2.4 on it all this time.  A friend of mine tried to upgrade one
to 2.6 and couldn't get it to boot.  I managed to get a bit of serial
console output of the error it is throwing.  I don't speak SCSI very
well, so I'm hoping that you guys might have some insight.

I added all the debug output that I could find.  I actually have a tiny
compile fix or two for the debug code that I'll send along in a bit.
I'm sure the other 3 MCA users will appreciate it.

Alan and James, you touched the file last, so you *must* be experts on it, right? ;)

IBM MCA SCSI: Version 4.0b-ac
IBM MCA SCSI: IBM SCSI-2 F/W Adapter found, io=0x3540, scsi id=7,
              ROM Addr.=off,<7> port-offset=0x0, subsystem=enabled.
IBM MCA SCSI: Control Register contents: 3, status: 4
IBM MCA SCSI: This adapters' POS-registers: fc 8e f1 ec 3c c7 0 ff 
IBM MCA SCSI: SCSI-Cache bits: 1111111111111111
IBM MCA SCSI: SCSI-Retry bits: 0000000000000000
IBM MCA SCSI: Separate bus mode (wide-addressing enabled)
IBM MCA SCSI: Sync.-Rate (F/W: 20, Int.: 10, Ext.: 5.00) MBytes/s
IBM MCA SCSI: Current SCSI-host index: 0
IBM MCA SCSI: Removing default logical SCSI-device
mapping................
IBM MCA SCSI: Scanning
SCSI-devices.............................................
IBM MCA SCSI: Mapping SCSI-devices.................
IBM MCA SCSI: Device order: IBM/ANSI (pun=7 is first).
IBM MCA SCSI: Determined SCSI-device-mapping:
    Physical SCSI-Device Map               Logical SCSI-Device Map
ID\LUN  0  1  2  3  4  5  6  7       ID\LUN  0  1  2  3  4  5  6  7
 0      -  -  -  -  -  -  -  -        0      0  -  -  -  -  -  -  - 
 1      -  -  -  -  -  -  -  -        1      1  -  -  -  -  -  -  - 
 2      D  +  +  +  +  +  +  +        2      2  -  -  -  -  -  -  - 
 3      -  -  -  -  -  -  -  -        3      3  -  -  -  -  -  -  - 
 4      -  -  -  -  -  -  -  -        4      4  -  -  -  -  -  -  - 
 5      -  -  -  -  -  -  -  -        5      5  -  -  -  -  -  -  - 
 6      -  -  -  -  -  -  -  -        6      6  -  -  -  -  -  -  - 
 7      A  A  A  A  A  A  A  A        7      f  f  f  f  f  f  f  f 
 8      -  -  -  -  -  -  -  -        8      7  -  -  -  -  -  -  - 
 9      -  -  -  -  -  -  -  -        9      8  -  -  -  -  -  -  - 
10      -  -  -  -  -  -  -  -       10      9  -  -  -  -  -  -  - 
11      -  -  -  -  -  -  -  -       11      a  -  -  -  -  -  -  - 
12      -  -  -  -  -  -  -  -       12      b  -  -  -  -  -  -  - 
13      -  -  -  -  -  -  -  -       13      c  -  -  -  -  -  -  - 
14      -  -  -  -  -  -  -  -       14      d  -  -  -  -  -  -  - 
15      -  -  -  -  -  -  -  -       15      e  -  -  -  -  -  -  - 
scsi0 : IBM SCSI-Subsystem
issue scsi cmd=12 to ldn=2
IBM MCA SCSI: Fatal Subsystem ERROR!
              Last cmd=0x12, ena=f600, len=36/8,Blocksize=0,
host=c3d0c000, ldn2
Blockcount=0/0
Logical block=0/0
Reason given: COMMAND ERROR
IBM MCA SCSI: Subsystem Error-Status follows:
              Command Type................: 30
              Attention Register..........: e2
              Basic Control Register......: 3
              Interrupt Status Register...: e2
              Basic Status Register.......: 4
              SCB-Command.................: 1c0b
              SCB-Enable..................: f600
              SCB-logical block address...: 0
              SCB-system buffer address...: 3d0c614
              SCB-system buffer length....: 8
              SCB-tsb address.............: 3d0c5f8
              SCB-Chain address...........: 0
              SCB-block count.............: 0
              SCB-block length............: 0
              Send this report to the maintainer.
Kernel panic - not syncing: IBM MCA SCSI: Fatal error message from the subsyste!

Pid: 0, comm: swapper Not tainted 2.6.30-rc7 #4
Call Trace:
 [<c0115f8e>] ? panic+0x3e/0x100
 [<c0284725>] ? interrupt_handler+0x3a5/0x810
 [<c013111a>] ? handle_IRQ_event+0x2a/0xb0
 [<c0132707>] ? handle_level_irq+0x47/0x90
 [<c0104377>] ? handle_irq+0x17/0x20
 [<c010431c>] ? do_IRQ+0x2c/0x70
 [<c0103009>] ? common_interrupt+0x29/0x30
 [<c0101ba7>] ? cpu_idle+0x17/0x40
 [<c04229d6>] ? start_kernel+0x206/0x240
Rebooting in 60 seconds..

-- Dave

