Return-Path: <linux-kernel-owner+w=401wt.eu-S1759735AbXHUTM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735AbXHUTM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbXHUTMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:12:19 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:39346 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291AbXHUTMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:12:18 -0400
Date: Tue, 21 Aug 2007 15:12:17 -0400
To: Marco Aicardi <marco@aicardi.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: DVD Burning with Asus M2NPV mainboard
Message-ID: <20070821191217.GF9412@csclub.uwaterloo.ca>
References: <1187716373.27251.10.camel@rolly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187716373.27251.10.camel@rolly>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 07:12:53PM +0200, Marco Aicardi wrote:
> [1.] One line summary of the problem:    
> 
>         Unable to burn DVD with the Asus M2NPV mainboard
> 
> [2.] Full description of the problem/report:
> 
>         I have recently changed my mainboard to a Asus M2NPV-VM one; nothing else was changed in the PC setup. From that moment on, I am unable to burn DVDs.
>         Both k3b and growisofs fail wih a generic input/output error.
>         
>         The same issue does not happen when mastering with other OSes.
> 
> [3.] Keywords (i.e., modules, networking, kernel):
> 
> [4.] Kernel version (from /proc/version):
> 
>         2.6.20-16 and 2.6.22-9
> 
> [5.] Output of Oops.. message (if applicable) with symbolic information 
>      resolved (see Documentation/oops-tracing.txt)
> 
>         root@rolly:~# growisofs -dvd-compat -Z /dev/dvd=test.iso
>         Executing 'builtin_dd if=test.iso of=/dev/dvd obs=32k seek=0'
>         /dev/dvd: FEATURE 21h is not on, engaging DAO...
>         /dev/dvd: reserving 2256139 blocks
>         /dev/dvd: "Current Write Speed" is 4.1x1352KBps.
>                   0/4620572672 ( 0.0%) @0x, remaining ??:?? RBU 100.0% UBU   0.0%
>         :-? the LUN appears to be stuck writing LBA=0h, keep retrying in 5ms
>                   0/4620572672 ( 0.0%) @0x, remaining ??:?? RBU 100.0% UBU   0.0%
>                   0/4620572672 ( 0.0%) @0x, remaining ??:?? RBU 100.0% UBU   0.0%
>         :-? the LUN appears to be stuck writing LBA=0h, keep retrying in 5ms
>                   0/4620572672 ( 0.0%) @0x, remaining ??:?? RBU 100.0% UBU   0.0%
>                   0/4620572672 ( 0.0%) @0x, remaining ??:?? RBU 100.0% UBU   0.0%
>         :-? the LUN appears to be stuck writing LBA=0h, keep retrying in 5ms
>            14516224/4620572672 ( 0.3%) @3.1x, remaining 116:20 RBU  97.2% UBU   3.2%
>            33587200/4620572672 ( 0.7%) @4.1x, remaining 56:54 RBU  90.5% UBU  90.3%
>            52658176/4620572672 ( 1.1%) @4.1x, remaining 41:55 RBU 100.0% UBU  90.3%
>            71729152/4620572672 ( 1.6%) @4.1x, remaining 33:49 RBU  97.1% UBU  90.3%
>            90800128/4620572672 ( 2.0%) @4.1x, remaining 29:06 RBU 100.0% UBU  90.3%
>         :-[ WRITE@LBA=bab0h failed with SK=4h/ASC=08h/ACQ=03h]: Input/output error
>         :-( write failed: Input/output error
>         /dev/dvd: flushing cache
 
Which device is hdc?  You should not have a slave without a master after
all, since that technically violates ATA specs as far as I know.

Do you have DMA enabled?  Are you even using a native driver for the
PATA interface (many distributions have a nasty habit of loading the
ide-generic driver when using SATA drives for the HDs and only optical
drives are on PATA).

The dmesg output at boot would give an idea as to which driver is used
for PATA drives.

DVD burning without DMA just doesn't work in general.  Also some DVD
drives require an 80wire cable to work reliably.  It does appear from
hdparm though that DMA is enabled, although I am never sure if I can
trust that part of hdparm so I ask /proc/ide/hdX/settings instead.
       
--
Len Sorensen
