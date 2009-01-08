Return-Path: <linux-kernel-owner+w=401wt.eu-S1763056AbZAHWbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763056AbZAHWbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZAHWbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:31:09 -0500
Received: from 1wt.eu ([62.212.114.60]:1286 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbZAHWbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:31:07 -0500
Date: Thu, 8 Jan 2009 23:30:57 +0100
From: Willy Tarreau <w@1wt.eu>
To: duane@duaneellis.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel 2.4.37 usb acm hard lockup
Message-ID: <20090108223056.GF5038@1wt.eu>
References: <20090108141921.5c1bb9f86d671edec44bb378f25c04cc.a190016ce1.wbe@email.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108141921.5c1bb9f86d671edec44bb378f25c04cc.a190016ce1.wbe@email.secureserver.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 08, 2009 at 02:19:21PM -0700, duane@duaneellis.com wrote:
> Hello, I have a linux-2.4.37 - kernel *HANG* hard lockup that I am
> trying to debug, ctl-alt-del does not fix the problem. The problem does
> not occur on current 2.6 kernels.
> 
> Specifically the device I am talking to is an USB-ACM type 'scanner'
> type device, it shows up as a USB com port /dev/input/ttyACM0 - and I
> read/write commands to & from the device.

You make me realize that I have never encountered an usb-acm device yet.
I did not even know what they were supposed to be :-/

> Some fixes have already been back ported from 2.6 (trying to get it to
> run on 2.4.20-8 [rh9]) and I'm not getting far and asking for some help
> or some pointers where to go next.
> 
> The bug is quite reproducible - I have a small C program, and a small
> shell script loop. It sends a few commands (ie: initialize, scan and
> transmit image) then saves the image to a file.  Somewhere between 70 to
> 150 scans BANG a hard hang occurs, takes between 5 to 15 minutes.
> 
> I get *NO* output on the console, like an oops or something like that.
> Only debug messages I have added in my program.
> 
> I have already turned the USB KERNEL debug messages on in the .config
> file, and I have "dmesg -n 9".
> 
> And - if I do add too many of my own debug messages, depending on the
> volume of messages the problem takes longer to appear or goes away (I
> give up after several hours) - which makes me think it is a timing/race
> condition :-(
> 
> If this is the wrong list, or there is a better list for this specific
> 2.4/usb/acm problem please let me know, I don't really know where else
> to ask.

Since it's probably the first time I read a report about usb-acm, I think
that this driver is very rarely used. So it may simply be broken or full
of race conditions or improper locking.

What you could do :
  - try without SMP if you're on an SMP machine.
  - try with an old gcc (2.95.3 is perfect for 2.4, 3.3 is good too).

Adding support for gcc 3.4 a few years ago was not easy, and it is
possible that some drivers are still not properly fixed.

Also, do you remember the latest 2.4 kernel where this driver worked
correctly (if any at all) ?

Regards,
Willy

