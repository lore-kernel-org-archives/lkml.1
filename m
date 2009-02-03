Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZBCJSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZBCJSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZBCJR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:17:59 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:45071 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZBCJR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:17:58 -0500
Message-ID: <49880BC3.7040901@cfl.rr.com>
Date: Tue, 03 Feb 2009 04:17:55 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Mark Hounschell <markh@compro.net>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD	Phenom-II
 processor
References: <20090120093732.GC3764@alberich.amd.com> <49763D49.7050907@compro.net> <49798F33.8070906@cfl.rr.com> <20090123130416.GA27616@alberich.amd.com> <497A48D5.9040904@cfl.rr.com> <497E0072.7000500@compro.net> <20090127163843.GA1628@aftab> <497FA725.7020503@cfl.rr.com> <497FA7F2.3060709@cfl.rr.com> <498416CE.4040101@cfl.rr.com> <20090202170506.GA19608@aftab>
In-Reply-To: <20090202170506.GA19608@aftab>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Sat, Jan 31, 2009 at 04:15:58AM -0500, Mark Hounschell wrote:
> 
> [..]
> 
>> So were you able to reproduce this with my .config. Has anyone booted a Hz=1000
>> kernel on an AMD Phenom-II? Is there something wrong with my .config? Is there
>> anything else I can do?
> 
> Hi,
> 
> sorry for the delay - I've been busy last week and couldn't get to your
> problem. So, I couldn't reproduce the bug here with a Phenom II and your
> kernel config. However, we have a working theory, so can you please send
> me the output of
> 
> xxd /sys/firmware/acpi/tables/APIC
> 

markh@harley:~> xxd /sys/firmware/acpi/tables/APIC
0000000: 4150 4943 8400 0000 014c 5258 3738 3020  APIC.....LRX780
0000010: 4157 5244 4143 5049 312e 3042 4157 5244  AWRDACPI1.0BAWRD
0000020: 0000 0000 0000 e0fe 0100 0000 0008 0000  ................
0000030: 0100 0000 0008 0101 0100 0000 0008 0202  ................
0000040: 0100 0000 0008 0303 0100 0000 010c 0400  ................
0000050: 0000 c0fe 0000 0000 020a 0000 0200 0000  ................
0000060: 0000 020a 0009 0900 0000 0f00 0406 0005  ................
0000070: 0001 0406 0105 0001 0406 0205 0001 0406  ................
0000080: 0305 0001

>
> Also, can you boot a 64-bit, HZ1000 kernel on your machine?
> 

No, a 64 bit kernel @1000Hz doesn't boot either. As with the 32 bit kernel,
setting Hz to 250 allows it to boot. The messages are slightly different when it
hangs on the 64bit kernel at 1000Hz.

Initializing CPU#0
PID hash table entries: 4096(order: 12,32768 bytes)
TSC calibrated against PM_TIMER
time.c Detected 3000.226 Mhz processor
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Node 0: aperture @4000000 size=32MB
Aperture pointing to e820 RAM, Ignoring.
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64MB of RAM
Mapping aperture over 65536 of RAM @4000000
PM: Registered nosave memory: 0000000004000000-0000000008000000
Memory: 4053644k/5242880k available (2355k kernel code, 140144k reserved, 1400k
data, 472 init)



Regards
Mark
