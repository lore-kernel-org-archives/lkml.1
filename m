Return-Path: <linux-kernel-owner+w=401wt.eu-S934485AbXILPkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485AbXILPkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 11:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764519AbXILPkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 11:40:32 -0400
Received: from outbound-mail-76.bluehost.com ([69.89.22.25]:56579 "HELO
	outbound-mail-76.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764060AbXILPkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 11:40:31 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Sep 2007 11:40:31 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Lossy interrupts on x86_64
Date: Wed, 12 Sep 2007 08:33:15 -0700
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709120833.15980.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.111.214.99 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just narrowed down a weird problem where I was losing more than 50% of 
my vblank interrupts to what seems to be the hires timers patch.  Stock 
2.6.23-rc5 works fine, but the latest (171) kernel from rawhide drops 
most of my interrupts unless I also have another interrupt source 
running (e.g. if I hold down a key or move the mouse I get the expected 
number of vblank interrupts, otherwise I get between 3 and 30 instead 
of the expected 60 per second).

Any ideas?  It seems like it might be bad APIC programming, but I 
haven't gone through those mods to look for suspects...

Thanks,
Jesse
