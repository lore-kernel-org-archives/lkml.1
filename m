Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbXEYM0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbXEYM0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXEYM02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:26:28 -0400
Received: from no-dns-yet.demon.co.uk ([83.105.13.114]:36980 "EHLO
	mailgate.netunix.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbXEYM01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:26:27 -0400
X-Greylist: delayed 1775 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 08:26:26 EDT
Message-ID: <4656CE39.8050800@netunix.com>
Date: Fri, 25 May 2007 12:53:29 +0100
From: Chris Newport <crn@netunix.com>
Reply-To: crn@netunix.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7) Gecko/20040618
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
References: <46558708.2040803@googlemail.com> <46559B54.80106@googlemail.com> <Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org> <20070524193740.GA6787@elte.hu> <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org> <20070525101105.GA9268@elte.hu>
In-Reply-To: <20070525101105.GA9268@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

>A BUG_ON() has a (much) lower likelyhood of being reported back - for 
>most users it is a "X just hung hard, there was nothing in the syslog, i 
>had to switch back to the older kernel" experience, and they do not have 
>a serial console to hook up (newer hardware often doesnt even have a 
>serial port). With the WARN_ON()s we have a _chance_ that despite the 
>seriousness of the bug, the message makes it to the syslog, until the 
>system comes to a screeching halt due to side-effects of the bug.
>
>in that sense i am part of the problem: i was adding WARN_ON()s that 
>werent true 'warnings' but 'bugs'. So i'd very much like to fix that 
>problem, but i'd also like to solve the (very serious and existing) 
>problem of BUG_ON()s making it less likely to get bugs reported back. 
>
>  
>
There is a fundamental problem in getting  a decent log to debug  a 
crashed kernel.  Maybe we should take a hint from Solaris.
If the kernel crashes Solaris dumps core to swap and sets a flag.
At the next boot this image is copied to /var/adm/crashdump where
it is preserved for future debugging. Obviously swap needs to be
larger than core, but this is usually the case.

On Sun machines this is fairly easy because the dump can be
performed by the OBP, on other architectures it may be more
difficult to still have enough working kernel to achieve the dump
after a kernel panic.

Just a thought .......


