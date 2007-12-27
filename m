Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbXL0UK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbXL0UK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 15:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbXL0UKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 15:10:20 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:19119 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752000AbXL0UKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 15:10:19 -0500
Message-ID: <477406A2.2070904@cfl.rr.com>
Date: Thu, 27 Dec 2007 15:10:10 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Siva Prasad <sprasad@bivio.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Device node - How does kernel know about it
References: <D83235F0F3C86D4D889D8B9A0DA8C6D7012AF95A@corpexc01.corp.networkrobots.com>
In-Reply-To: <D83235F0F3C86D4D889D8B9A0DA8C6D7012AF95A@corpexc01.corp.networkrobots.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Dec 2007 20:11:00.0146 (UTC) FILETIME=[99386920:01C848C4]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15632.001
X-TM-AS-Result: No--9.310600-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siva Prasad wrote:
> Hi,
> 
> How do the device nodes work as an interface between user and kernel
> programs, and how to go debugging it? 
> This is as part of my debugging effort on an embedded board.

The filesystem sets specific bits in the mode mask and elsewhere in the 
inode to mark the file as a dev node, and which major/minor device 
number it should be linked to.  The kernel device drivers register to 
handle a given device number.

> * It all started with the problem of "not printing" any thing that comes
> from ramdisk (echo and printf statements), while kernel printk's work
> perfectly fine.
> * Ramdisk is also executing fine, just that prints are not coming out of
> serial. I can see the execution of various user programs with a printk
> in sys_execve() routine. Ramdisk has all the required files like
> /dev/console, /dev/ttyS0, etc.

So you did you pass the console=ttyS0 parameter to the kernel?  Did you 
configure your inittab to spawn the getty on the serial port instead of 
/dev/ttyN?  You might want to take a look at the Linux Serial Console 
HOWTO.


