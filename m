Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbYKYUij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbYKYUij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 15:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYKYUib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 15:38:31 -0500
Received: from ptb-relay03.plus.net ([212.159.14.147]:51574 "EHLO
	ptb-relay03.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYKYUi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 15:38:29 -0500
Message-ID: <492C6238.7060507@mimc.co.uk>
Date: Tue, 25 Nov 2008 20:38:16 +0000
From: Mark Jackson <mpfj@mimc.co.uk>
Organization: Mercury IMC Ltd
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Help using initramfs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Plusnet-Relay: e2e2c187d69a949adeca976d9ae85d1c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if this is the correct place to be asking, but I've spend a 
while searching Google and am still no wiser.

I'm looking to use initramfs to create a simple bootable linux distro 
for our AVR32 based boards.

However, I have hit a brick wall at nearly the first step.

So far I've managed to create a "bloated" kernel containing the 
initramfs directory structure and I'm just trying to get a simple "Hello 
World" test app running.

The kernel boots, and the app runs, but I get no output on the console.

I'm sure the app is running, because I can alter a call to sleep() which 
affects the time before a "Kernel panic" message is shown on the console.

I'm running:-

Linux 2.6.27-rc8
Buildroot (svn)
Busybox 1.12.1
uClibc 0.9.29

The kernel command line is:-
rw console=ttyS1 root=/dev/null rdinit=/hello

"hello" is a simple app:-

#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
     printf("Hello world!\n");
     sleep(999999999);
}

The console output is shown below.

I know there's not much info to go on, so if anyone can point me in the 
right direction, I'd be most grateful.

Regards
Mark

---
Linux version 2.6.27-rc8 (mpfj@mpfj-ubuntu) (gcc version 
4.2.2-atmel.1.0.8) #66 Tue Nov 25 20:07:45 GMT 2008
CPU: AT32AP700x chip revision C
CPU: AP7 [01] core revision 0 (AVR32B arch revision 1)
CPU: MMU configuration: Shared TLB
CPU: features: dsp simd ocd perfctr java
CPU: Running at 150.000 MHz
Physical memory:
   10000000-11ffffff
Reserved memory:
   10000000-101ff4cd: Kernel code
   101ff4ce-102856af: Kernel data
Exception vectors start at 90086000
CPU: Paging enabled
Node 0: start_pfn = 0x10000, low = 0x12000
Node 0: mem_map starts at 90288000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line: rw console=ttyS1,115200 root=/dev/null rdinit=/hello
PID hash table entries: 128 (order: 7, 512 bytes)
avr32_comparator: irq 0, 150.000 MHz
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Memory: 29896k/29896k available (1509k kernel code, 2872k reserved, 107k 
data, 536k init)
SLUB: Genslabs=10, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay using timer specific routine.. 301.73 BogoMIPS 
(lpj=603473)
Mount-cache hash table entries: 512
net_namespace: 440 bytes
NET: Registered protocol family 16
smc smc.0: Atmel Static Memory Controller at 0xfff03400
pdc pdc.0: Atmel Peripheral DMA Controller enabled
at32_eic at32_eic.0: External Interrupt Controller at 0xfff00100, IRQ 19
at32_eic at32_eic.0: Handling 4 external IRQs, starting with IRQ 64
AVR32 AP Power Management enabled
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP reno registered
NET: Registered protocol family 1
FRAM memory driver v1.0
JFFS2 version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
msgmni has been set to 58
io scheduler noop registered
io scheduler cfq registered (default)
atmel_lcdfb atmel_lcdfb.0: 600KiB frame buffer at 11f00000 (mapped at 
b1f00000)
atmel_lcdfb atmel_lcdfb.0: fb0: Atmel LCDC at 0xff000000 (mapped at 
ff000000), irq 1
atmel_usart.0: ttyS0 at MMIO 0xffe00c00 (irq = 6) is a ATMEL_SERIAL
atmel_usart.1: ttyS1 at MMIO 0xffe01000 (irq = 7) is a ATMEL_SERIAL
console [ttyS1] enabled
atmel_usart.2: ttyS2 at MMIO 0xffe01400 (irq = 8) is a ATMEL_SERIAL
atmel_usart.3: ttyS3 at MMIO 0xffe01800 (irq = 9) is a ATMEL_SERIAL
brd: module loaded
loop: module loaded
MACB_mii_bus: probed
eth0: Atmel MACB at 0xfff01800 irq 25 (00:19:54:32:f5:4a)
eth0: attached PHY driver [Generic PHY] (mii_bus:phy_addr=0:01, irq=-1)
MACB_mii_bus: probed
eth1: Atmel MACB at 0xfff01c00 irq 26 (00:19:54:32:f5:4c)
eth1: attached PHY driver [Generic PHY] (mii_bus:phy_addr=1:03, irq=-1)
physmap platform flash device: 00800000 at 00000000
physmap-flash.0: Found 1 x16 devices at 0x0 in 16-bit bank
  Amd/Fujitsu Extended Query Table at 0x0040
number of CFI chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
RedBoot partition parsing not available
Using physmap partition information
Creating 4 MTD partitions on "physmap-flash.0":
0x00000000-0x00020000 : "u-boot"
0x00020000-0x007e0000 : "root"
0x007e0000-0x007f0000 : "splash"
0x007f0000-0x00800000 : "env"
physmap platform flash device: 00800000 at 08000000
physmap-flash.1: Found 1 x16 devices at 0x0 in 16-bit bank
  Amd/Fujitsu Extended Query Table at 0x0040
number of CFI chips: 1
cfi_cmdset_0002: Disabling erase-suspend-program due to code brokenness.
RedBoot partition parsing not available
Using physmap partition information
Creating 1 MTD partitions on "physmap-flash.1":
0x00000000-0x00800000 : "data"
at32_wdt at32_wdt.0: AT32AP700X WDT at 0xfff000b0, timeout 2 sec 
(nowayout=0)
atmel_mci atmel_mci.0: Atmel MCI controller at 0xfff02400 irq 28, 1 slots
dw_dmac.0: DesignWare DMA Controller, 3 channels
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
NET: Registered protocol family 15
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
cpufreq: AT32AP CPU frequency driver
Freeing init memory: 536K (90000000 - 90086000)

