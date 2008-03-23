Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYCWGg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYCWGg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 02:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYCWGgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 02:36:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55966 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbYCWGgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 02:36:18 -0400
Date: Sun, 23 Mar 2008 07:35:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Thomas Meyer <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
	regressions from 2.6.24)
Message-ID: <20080323063524.GA13018@elte.hu>
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E59B39.90306@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E59B39.90306@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> On my x86-32 test system, none of the devices gets an MMIO region 
> above the 4G map.  (Reconfigured with CONFIG_RESOURCES_64BIT=y while 
> having CONFIG_HIGHMEM4G=y, like in Thomas M's .config.)

64-bit ioremap on x86 never worked AFAIK, the whole API is using 32-bit 
physical addresses which is limited to 4GB. But ... this bug does have 
the feeling of the wrong IO side physical memory being mapped. (0xff 
data means there's no device there - typical of non-existent RAM/IO)

could you please pull the x86/latest tree to do a kernel pagetable dump 
for us? You can pull it via the instructions here:

   http://people.redhat.com/mingo/x86.git/README

then enable CONFIG_DEBUG_KERNEL=y and CONFIG_X86_PTDUMP=y boot the 
kernel so that ohci1394 doesnt work. Then dump the pagetables and other 
hw info via:

   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

send us the cfs-debug-info file that gets generated. We'll be able to 
tell from that whether your ioremap's are OK. (x86/latest will also 
printk all ioremap()s and results that are done)

thanks,

	Ingo
