Return-Path: <linux-kernel-owner+w=401wt.eu-S1760507AbYDLH2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760507AbYDLH2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 03:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbYDLH23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 03:28:29 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:49833 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754316AbYDLH22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 03:28:28 -0400
Subject: Re: BUG: soft lockup detected on Phenom with Debian 2.6.24-4
From: Laurent GUERBY <laurent@guerby.net>
To: linux-kernel@vger.kernel.org
Cc: Peter Oruba <peter.oruba@amd.com>
In-Reply-To: <1206123836.15075.699.camel@localhost>
References: <1205013615.15075.409.camel@localhost>
	 <1205678588.15075.563.camel@localhost>
	 <1206015619.15075.666.camel@localhost>  <47E26A5D.40401@amd.com>
	 <1206123836.15075.699.camel@localhost>
Content-Type: text/plain
Date: Sat, 12 Apr 2008 09:28:24 +0200
Message-Id: <1207985304.15628.415.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 82.235.162.148 (gut75-4-82-235-162-148.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
X-Ovh-Tracer-Id: 8915438413911432727
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

FYI with Peter off-list help we found a way to make the ASUS M2A-VM with
1604 BIOS stable under my stress test: we just needed nmi_watchdog=1 in
the kernel boot options (no other boot option necessary).

With nmi_watchdog=1 we see in kern.log "APIC error" but
the machine stayed stable during 3 days of stress testing:

...
Apr  7 22:41:43 gcc04 kernel: APIC error on CPU2: 00(40)
Apr  7 22:41:43 gcc04 kernel: APIC error on CPU1: 00(40)
Apr  7 22:41:43 gcc04 kernel: APIC error on CPU3: 00(40)
Apr  7 22:41:43 gcc04 kernel: APIC error on CPU0: 00(40)
Apr  7 22:53:01 gcc04 kernel: APIC error on CPU3: 40(40)
Apr  7 22:53:01 gcc04 kernel: APIC error on CPU0: 40(40)
Apr  7 22:53:01 gcc04 kernel: APIC error on CPU1: 40(40)
...

guerby@gcc04:~$ cat /proc/cmdline 
root=/dev/sda1 ro nmi_watchdog=1

We are now stress testing the 1705 BIOS version which was released by
ASUS on 20080331, with and without nmi_watchdog=1. Then we'll go
back to testing the ASUS M3A32-MVP Deluxe/WiFi-AP with the newer 1002
BIOS also released on 20080331.

Note: for msr decoding xxd should be used since hexdump doesn't work:

xxd -s 0xc0010015 -l 8 /dev/cpu/0/msr

So people having stability problems with Phenom 9x00 with Linux should
try nmi_watchdog=1 as boot option.

Sincerely,

Laurent


