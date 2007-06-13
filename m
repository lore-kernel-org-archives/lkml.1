Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbXFMJgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbXFMJgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 05:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbXFMJfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 05:35:54 -0400
Received: from tornado.reub.net ([210.185.126.1]:38561 "EHLO tornado.reub.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637AbXFMJfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 05:35:54 -0400
Message-ID: <466FBA70.6080704@reub.net>
Date: Wed, 13 Jun 2007 19:35:44 +1000
From: Reuben Farrelly <reuben-linuxkernel@reub.net>
User-Agent: Thunderbird 2.0.0.5pre (Windows/20070612)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [Serial port bug?]  was Re: 2.6.22-rc4-mm2
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/06/2007 3:03 PM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/
> 
> - Basically a bugfixed version of 2.6.22-rc4-mm1.  None of the subsystem
>   trees were repulled, several bad patches were dropped, a few were fixed.

I've come home to find my server has locked up hard, with a panic on the screen. 
  This time unlike others, I was able to grab a photo of it for further analysis.

http://www.reub.net/files/kernel/     serial-crash.jpg

[Note also the .config and dmesg in the same directory]

I have had this or a very similar traceback appear about 3 or 4 times now, 
including with a 2.6.21-gentoo kernel (based on mainline), so this bug may well 
be present in mainline.  It is not new to this -mm release.

The bug does not occur on demand, it just seems to happen every few days without 
obvious warning, I haven't reported it until now as I haven't had any other 
information to provide other than "some panic seems to happen with a tty_write 
something-or-other".

The other possibly crucial piece of information on this is that I have one of my 
serial ports set up as a serial console.  The kernel boot commands for this are:

kernel /vmlinuz-2.6.22-rc4-mm2 ro real_root=/dev/md2 console=tty0 
console=ttyS0,57600 panic=30

as well as this:

# SERIAL CONSOLES
s0:12345:respawn:/sbin/agetty 57600 ttyS0 vt100

in inittab.

The other serial port is connected up to my APC UPS and is set up with apcupsd.

Reuben
