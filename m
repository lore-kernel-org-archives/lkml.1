Return-Path: <linux-kernel-owner+w=401wt.eu-S1751043AbXBFLSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043AbXBFLSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 06:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbXBFLSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 06:18:10 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:43434 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbXBFLSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 06:18:09 -0500
Message-ID: <45C86405.1070902@gmail.com>
Date: Tue, 06 Feb 2007 12:18:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@suse.cz>, linux-pm@osdl.org
Subject: Re: hwsusp defunct
References: <45C5DBBA.20502@gmail.com> <200702041452.28874.rjw@sisk.pl>
In-Reply-To: <200702041452.28874.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> Hi,
> 
> On Sunday, 4 February 2007 14:12, Jiri Slaby wrote:
>> Hi.
>>
>> When I'm trying to suspend to mem one machine, it wakes immediatly back with 
>> nothing notable in dmesg:
> [--snip--] 
>> Will PM_DEBUG or ACPI_DEBUG help somehow? Or later kernel?
> 
> Later kernel might help, some important fixes have gone in since 2.6.19,
> PCI quirks-related etc.
> 
> Please try 2.6.20-rc7 and if that doesn't help, try the latest -mm.

2.6.20 from init 2 is no go either, -mm (-rc6-mm3) with minimal config [1] 
suspends, no key was able to resume it back, only power button, but monitor 
doesn't wake (actually I've this problem on another machine when X is not 
running) -- how to debug both of this? Do not suspend consoles? PM_TRACE (this 
won't help since it completely resumes, I guess)?

This is blindly written dmesg after resume. See it whole at [2]:
Suspending device 0.0
ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index (000000007) is beyon
d end of object [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.GTM_]
(Node dfe64fcc), AE_AML_PACKAGE_LIMIT
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0._
GTM] (Node dfe649f0), AE_AML_PACKAGE_LIMIT
...
hda: selected mode 0x45
ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA]
(Node dfe64ec8), AE_AML_OPERAND_VALUE
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.D
RV1._GTF] (Node dfe64964), AE_AML_OPERAND_VALUE
do_drive_get_GTF: Run _GTF error: status = 0x3006


$ ls -l /sys/block/hda/device
lrwxrwxrwx 1 root root 0 úno  6 12:14 /sys/block/hda/device -> 
../../devices/pci0000:00/0000:00:1f.1/ide0/0.0
$ ls -l /sys/block/hda/device/driver
lrwxrwxrwx 1 root root 0 úno  6 12:15 /sys/block/hda/device/driver -> 
../../../../../bus/ide/drivers/ide-disk
$ ls -l /sys/block/hda/device/driver/0.0
lrwxrwxrwx 1 root root 0 úno  6 12:16 /sys/block/hda/device/driver/0.0 -> 
../../../../devices/pci0000:00/0000:00:1f.1/ide0/0.0
# lspci -vvvxxs 0000:00:1f.1
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller 
(rev 02) (prog-if 8a [Master SecP PriP])
         Subsystem: ASUSTeK Computer Inc. P5P800-MX Mainboard
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 5
         Region 0: I/O ports at 01f0 [size=8]
         Region 1: I/O ports at 03f4 [size=1]
         Region 2: I/O ports at 0170 [size=8]
         Region 3: I/O ports at 0374 [size=1]
         Region 4: I/O ports at fc00 [size=16]
         Region 5: Memory at 30100000 (32-bit, non-prefetchable) [size=1K]
00: 86 80 db 24 07 00 80 02 02 8a 01 01 00 00 00 00
10: 01 00 00 00 01 00 00 00 01 00 00 00 01 00 00 00
20: 01 fc 00 00 00 00 10 30 00 00 00 00 43 10 a6 80
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00

Do you want acpidump? Should I test 2.6.20 with minimal config?

[1]
   http://www.fi.muni.cz/~xslaby/sklad/config-mm
[2]
   http://www.fi.muni.cz/~xpapiez/test/dmesg-mm.txt

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
