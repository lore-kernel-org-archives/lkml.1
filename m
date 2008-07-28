Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYG1HFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYG1HFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 03:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYG1HFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 03:05:07 -0400
Received: from main.gmane.org ([80.91.229.2]:51965 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYG1HFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 03:05:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: David W Studeman <avionicsdv@aim.com>
Subject: Keyboard Jammed error patch 2.4.35-pre4
Date: Sun, 27 Jul 2008 23:59:47 -0700
Message-ID: <g6jqud$t5e$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-71-112-171-94.sttlwa.dsl-w.verizon.net
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1a2pre) Gecko/2008072700 SeaMonkey/2.0a1pre
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello! The changes that were made on 04-25-2007 as "[PATCH 
2.4.35-pre4] fix 'pc_keyb: controller jammed (0xA7)' error" have broken 
the ability to compile with no keyboard and no VT support. This mainly 
affects Cobalt machines which do not have dmi present as these use a 
flashrom to boot with and not a typical bios so dmi blacklisting would 
be pointless unless it allowed for no dmi present and then blacklist. I 
had to create a patch against 2.4.34 to restore the ability to compile 
with no keyboard and VT support.

With keyboard support whether embedded or modularized, in a Raq/Qube3 
and Raq4, it simply gives off a warning in the serial console if you are 
watching it boot, a Raq 550 on the other hand shows it as an error about 
300 times and will also show up in the dmesg log. Unless one was to fix 
the dmi blacklisting to disable when no dmi is present as is the case 
here, it needs to be fixed to allow compiling without. A Cobalt can only 
use two methods of terminal access, one being serial console and ssh 
being the other.

These units do not use a typical bios but rather a flashrom on a 1 OR 
2mb flash chip depending on model. The flashrom image contains it's own 
kernel and Cobalt utilities and starts it's own boot process and looks 
for a bzipped vmlinux image in boot to hand off to when it's time to 
actually boot your OS. You have to set the boot and root partition in it 
the first time and it does not care about or see any bootloader you may 
have installed. It also does not give off any info about itself either. 
Sure, the required embedded Cobalt drivers will tell something from 
/proc/cobalt but that's about it.

This ability to compile without had been broken and restored back in 
kernel 2.4.31 and then as of the 2.4.35.4 it has been broken since. I'm 
involved in making a Cobalt build of IPCop and would love it if I didn't 
have to patch for this in addition to the rest that is required to make 
a Raq/Qube run.

Dave Studeman

