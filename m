Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbXBWPys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbXBWPys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 10:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932713AbXBWPys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 10:54:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33066 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbXBWPyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 10:54:47 -0500
Subject: Re: irq balancing question
From: Arjan van de Ven <arjan@infradead.org>
To: Gergely Imre <imre.gergely@astral.ro>
Cc: linux-kernel@vger.kernel.org, hancockr@shaw.ca
In-Reply-To: <45DF012D.3080802@astral.ro>
References: <45DED0D6.1040700@astral.ro>
	 <1172241917.3241.4.camel@laptopd505.fenrus.org>
	 <45DF012D.3080802@astral.ro>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 23 Feb 2007 16:54:45 +0100
Message-Id: <1172246085.3241.24.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> in fact i have two cards, and 4 CPUs, but i was interested in then answer
> Robert gave, that only _some_ machines distribute interrupts in hardware.
> software distribution is obviously not good. consider this scenario:
> 
> you have one machine with 4 cpus, and two ethernet cards with a lot of
> traffic on them. if you bind every card to one cpu, two of them are not used,
> so you really use only half the power. not let's say you have so much traffic
> (with limiting enabled, htb or something), that the two CPUs are on 100% all
> the time, but the other two are doing nothing.
> 
> now if you could balance that to all 4 cpus, you could use all the power AND
> no cpu would be used 100%.

actually this will give you worse performance than only using 2 cores.
The reason for this is twofold
1) If you rotate the irqs, TCP and IP packet fragments will arrive at
different CPUs. This in turn means that a VERY expensive reassembly path
gets taken, compared to local-cpu-only reassembly
2) If you rotate the irqs, you bounce cachelines between the caches ALL
THE TIME, which is also very expensive.

Both make it more likely that you'll be slower than just using only 2
cores...



-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

