Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbYGAOIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbYGAOIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757747AbYGAOGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:06:53 -0400
Received: from server15.01domain.net ([216.7.191.132]:42580 "EHLO
	server15.01domain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146AbYGAOGv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:06:51 -0400
X-Greylist: delayed 1579 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2008 10:06:51 EDT
Message-ID: <20080701234031.xajpvkek4kc8ckss@omnitude.net>
Date: Tue, 01 Jul 2008 23:40:31 +1000
From: Adam Swift <vikeul@omnitude.net>
To: linux-kernel@vger.kernel.org
Cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Subject: CONFIG_8139TOO_PIO needed with RT patches
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.6)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server15.01domain.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - omnitude.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm encountering a strange problem on the 2.6.24.7-rt14 kernel. I have  
a machine that uses the 8139too driver for its ethernet. This works  
fine at normal and high throughput with CONFIG_8139TOO_PIO both off  
and on, with both the stock Fedora 8 kernel and an unpatched 2.6.24.7  
kernel. However, on the Planet CCRMA realtime kernel, and a vanilla  
2.6.24.7-rt14, with CONFIG_8139TOO_PIO off the machine locks up at  
somewhat high throughput. I can trigger this by piping a large file  
over a netcat connection. I tested it at lower throughputs, and it  
seems to be fine at <128KiB/s but dies at >1MiB/s.

When I say locks up, I mean completely- ctrl-alt-del does nothing,  
magic sysrq does nothing, and num lock does not even respond. The  
keyboard lights do not flash to indicate kernel panic, and nothing  
gets into /var/log/messages or dmesg.

I understand that CONFIG_8139TOO_PIO is provided to cater for broken  
motherboards, which mine may be. However doesn't a difference between  
the behaviour on the RT and normal kernel indicate a problem somewhere  
with the RT kernel?

The kernel config that triggers it (with 2.6.24.7-rt14) can be found  
at http://omnitude.net/vike/rt.config , lspci -vv output at  
http://omnitude.net/vike/lspcivv . Hardware info:
Motherboard: Asrock P4I65G, using the onboard graphics
CPU: Intel Pentium IV 2.8GHz
RAM: 1GB of DDR
Plus a generic PCI Firewire card which has the VIA chip listed in the  
lspci output.

Please CC me as I'm not on the list.

Thanks,
Adam Swift

