Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbXGXSyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbXGXSyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbXGXSxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:53:54 -0400
Received: from disorder.primate.net ([198.144.194.12]:46706 "EHLO
	disorder.primate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbXGXSxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:53:53 -0400
Date: Tue, 24 Jul 2007 11:53:51 -0700
From: Aaron Porter <atporter@primate.net>
To: Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: miserable performance of 2.6.21 under network load
Message-ID: <20070724185351.GE24543@primate.net>
References: <20070724172513.GB24543@primate.net> <46A649CB.7080401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A649CB.7080401@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 02:49:47PM -0400, Chris Snook wrote:
> Is it always CPU 0, or does it move?  Are you running irqbalance?  If 
> you're running irqbalance, you can run a script that alternates between 
> 'cat /proc/interrupts' and 'mpstat -P ALL 5 10' and watch the offending 
> interrupt jump around between processors.  It's not as informative as 
> oprofile, as Andi suggested, but it's really easy to set up.

	Always cpu0

# cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       
  0:        166          0          0          0    XT-PIC-XT        timer
  1:          8          0          0          0    XT-PIC-XT        i8042
  2:          0          0          0          0    XT-PIC-XT        cascade
  3:         11          0          0          0    XT-PIC-XT        serial
  4:        830          0          0          0    XT-PIC-XT        serial
  5:  370787109          0          0          0    XT-PIC-XT        eth0
  6:          3          0          0          0    XT-PIC-XT        floppy
  8:          4          0          0          0    XT-PIC-XT        rtc
  9:          0          0          0          0    XT-PIC-XT        ohci_hcd:usb1, ohci_hcd:usb2
 10:   80937699          0          0          0    XT-PIC-XT        3w-9xxx, 3w-9xxx
 12:          5          0          0          0    XT-PIC-XT        i8042
 14:      50931          0          0          0    XT-PIC-XT        ide0
NMI:    1110304     275156     276732     233082 
LOC:  278410000  278410022  278410013  278410014 
ERR:   55003177
MIS:          0
# mpstat -P ALL 5 1 
Linux 2.6.21.5 (*.com)      07/24/07

11:52:30     CPU   %user   %nice %system %iowait    %irq   %soft   %idle    intr/s
11:52:35     all    0.40    0.00   16.12   13.56    0.25   25.13   44.54    299.80
11:52:35       0    0.00    0.00    0.00    0.00    1.00   99.00    0.00    299.80
11:52:35       1    0.80    0.00   23.65   23.05    0.00    0.40   52.10      0.00
11:52:35       2    0.40    0.00   21.64   14.23    0.00    0.40   63.53      0.00
11:52:35       3    0.60    0.00   19.44   17.03    0.00    0.60   62.73      0.00

Average:     CPU   %user   %nice %system %iowait    %irq   %soft   %idle    intr/s
Average:     all    0.40    0.00   16.12   13.56    0.25   25.13   44.54    299.80
Average:       0    0.00    0.00    0.00    0.00    1.00   99.00    0.00    299.80
Average:       1    0.80    0.00   23.65   23.05    0.00    0.40   52.10      0.00
Average:       2    0.40    0.00   21.64   14.23    0.00    0.40   63.53      0.00
Average:       3    0.60    0.00   19.44   17.03    0.00    0.60   62.73      0.00
# 
