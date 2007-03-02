Return-Path: <linux-kernel-owner+w=401wt.eu-S933641AbXCEViD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbXCEViD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933638AbXCEViD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:38:03 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4526 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933635AbXCEViA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:38:00 -0500
Date: Fri, 2 Mar 2007 19:56:50 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Marco Lazzarotto <m.lazzarotto@robox.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Trouble using some (fast) compact flash as ide device on an embedded system
Message-ID: <20070302195650.GA5697@ucw.cz>
References: <45E6D7EB.5080501@robox.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E6D7EB.5080501@robox.it>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> As I reported in bug 8036 in bugzilla.kernel.org,
> 
> Hardware Environment:
> 
>  - Use a compact flash SanDisk SDCFB-128 Firmware revision HDX 2.15
>    (we used other compact flashes with the same hw ad sw for years
>     with  no trouble)
> 
> It happens on both etx boards:
>  - VIA SOM-ETX (4475)
>  - Gene-4312
> 
> Doing the command
> sfdisk -R /dev/hdc
> 
> gives:
> 
>  * * *
> ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
> hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> ide: failed opcode was: unknown
> hdc: drive not ready for command
> ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
> hdc: do_special: 0x02
> hdc: do_special: recalibrate
> ide1: start_request: current=0xc6ebe754 (rq->sect=0,block 0)
> hdc: reading: block=0 sectors=8, buffer = 0xc6cd40000
> ide1: end_request: current=0xc6ebe754
>  * * *
> 
> the 'bad bit' in status error is DataRequest
> 
> 
> 
> doing
> sfdisk -l /dev/hdc
> 
> gives:
> 
>  * * *
> ide1: start_request: current=0xc6ebecd4 (rq->sect=0,block 0)
> hdc: reading: block=0, sectors=32, buffer=0xc6f37000
> hdc: lost interrupt
> hdc: lost interrupt [and so on several times]
>  * * *
> 
> I have no knowledge of the internals of the linux kernel, but I'm a
> programmer and have both hardware and time to spend on solving this issue.

Debug it, then :-). Try limiting its speed with hdparm to see if it
helps.
