Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815Ab0AITwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab0AITwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 14:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911Ab0AITwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 14:52:12 -0500
Received: from mx.treblig.org ([80.68.94.177]:46657 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab0AITwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 14:52:11 -0500
Date: Sat, 9 Jan 2010 19:46:55 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: "Paul G. Allen" <pgallen@gmail.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux Serial Performance
Message-ID: <20100109194655.GA28639@gallifrey>
References: <bd8e30a41001091057t97f90abgffe9cca329ace477@mail.gmail.com> <20100109191025.GK4757@const.famille.thibault.fr> <bd8e30a41001091132m611a2054i3ed4098111e005cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd8e30a41001091132m611a2054i3ed4098111e005cb@mail.gmail.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.31.5-kvm-i386-2009-10-30 (i686)
X-Uptime: 19:44:24 up 55 days,  2:54,  2 users,  load average: 0.06, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul G. Allen (pgallen@gmail.com) wrote:
> Well, as far as I know. Same code on both systems. The embedded device
> operates at 115200, 8N1, no flow control. It uses RPC/SLIP protocol
> for commands and data. They talk to each other, but the Linux system
> just takes forever to send the data.

What does the RPC/SLIP - the app or the Kernel?

If you have no flow control is it possible that someone is dropping a byte
somewhere any recovering?

If your device is set at the right speed (check with stty -a < /dev/ttyS??? )
then what speed does :

dd if=/dev/zero of=/dev/ttyS??? bs=1 count=10000

show, for my line set at 9k6 (on ttyS0) it's showing 1.0kB/s which
seems about right.

What's the serial card - is it an onboard card or a PCI plug in,
I've seen problems on Linux a few times where the device driver
has the speed of some plugin cards out by a factor of 8.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
