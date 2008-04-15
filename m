Return-Path: <linux-kernel-owner+w=401wt.eu-S1765511AbYDOUXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765511AbYDOUXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762992AbYDOUXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:23:38 -0400
Received: from 1wt.eu ([62.212.114.60]:3119 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYDOUXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:23:37 -0400
Date: Tue, 15 Apr 2008 22:14:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: Anton Titov <a.titov@host.bg>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: Bad network performance over 2Gbps
Message-ID: <20080415201441.GE8474@1wt.eu>
References: <1208282804.23631.27.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208282804.23631.27.camel@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 09:06:44PM +0300, Anton Titov wrote:
> I use Linux for serving a huge amount of static web on few servers. When
> network traffic goes above 2Gbit/sec ksoftirqd/5 (not every time 5, but
> every time just one) starts using exactly 100% CPU time and packet
> packet loss starts preventing traffic from going up. When the network
> traffic is lower than 1.9Gbit ksoftirqds use 0% CPU according to top.
> 
> Uplink is 6 gigabit Intel cards bonded together using 802.3ad algorithm
> with xmit_hash_policy set to layer3+4. On the other side is Cisco 2960
> switch. Machine is with two quad core Intel Xeons @2.33GHz.
> 
> Here goes a screen snapshot of "top" command. The described behavior
> have nothing to do with 13% io-wait. It happens even if it is 0%
> io-wait.
> http://www.titov.net/misc/top-snap.png
> 
> kernel configuration:
> http://www.titov.net/misc/config.gz
> 
> /proc/interrupts, lspci, dmesg (nothing intresting there), ifconfig,
> uname -a:
> http://www.titov.net/misc/misc.txt.gz
> 
> Is it a Linux bug or some hardware limitation?

possibly some missing parameters when loading your e1000 drivers.
e1000 NICs support interrupt rate limitation, which proves very
efficient in cases such as yours. I'm used to limit them to about
5k ints/s. Do a "modinfo e1000" to get the parameter name, I don't
have it quite right in mind.

Also, I've CCed linux-net.

Regards,
Willy

