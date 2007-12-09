Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXLIAwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXLIAwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 19:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXLIAv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 19:51:57 -0500
Received: from loadbalancer2.orcon.net.nz ([219.88.242.4]:59635 "EHLO
	mx5.orcon.net.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753025AbXLIAv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 19:51:56 -0500
Message-ID: <475B3C23.6010304@orcon.net.nz>
Date: Sun, 09 Dec 2007 13:51:47 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Bob Tracy <rct@frus.com>, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org,
       greg@kroah.com
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
References: <20071208050517.EC35EDBA2@gherkin.frus.com> <1197128912.5483.51.camel@lov.site>
In-Reply-To: <1197128912.5483.51.camel@lov.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx5.orcon.net.nz on Sun, 09 Dec 2007 13:51:49 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Dec  9 13:51:52 2007
X-DSPAM-Confidence: 0.8469
X-DSPAM-Improbability: 1 in 554 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Fri, 2007-12-07 at 23:05 -0600, Bob Tracy wrote:
>> Kay Sievers wrote:
>>> Is the udev daemon (still) running while it fails?
>> Yes, and there's something else I forgot to mention that may be
>> significant...  For the bad case, in addition to udevd, "ps -ef"
>> shows a "sh -e /lib/udev/net.agent" running with a PPID of 1.  This
>> process doesn't exit until I reboot.  If this is normal under the
>> circumstances, please disregard.
> 
> Does SysRq-T show where it hangs?

Ummm... No.  I didn't have the CONFIG_MAGIC_SYSRQ flag set, so I set it, 
and recompiled the kernel.  Guess what - now the system comes up 
normally without any problem.  The block devices appear in /dev.  To 
recap: without CONFIG_MAGIC_SYSRQ on the 2.6.24-rc3 kernel the missing 
block devices error in /dev occurs and the init scripts fall over on 
startup, and with CONFIG_MAGIC_SYSRQ the system comes up normally.

To answer the earlier questions about distro, and udev version, my 
system is similar to Bob's, except that I am running Debian 
testing/lenny which comes with udev version 114 (dpkg reports udev 
version 0.114-2).  I am running an EV67 variant CPU.

I do not run an initramfs - I have the necessary drivers for the various 
discs compiled into the kernel and use the root kernel option to point 
to the required root partition.

When running the broken kernel udev is running (according to 'ps') and 
executing /sbin/udevtrigger manually generates a number of errors of the 
form:

scsi_id[<pid>]: scsi_id: unable to access '/block'

The missing /dev/* entries do not appear.

Cheerz
Michael.
