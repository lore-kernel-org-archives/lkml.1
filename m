Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbXLBOQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbXLBOQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 09:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbXLBOQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 09:16:49 -0500
Received: from lazybastard.de ([212.112.238.170]:54954 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbXLBOQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 09:16:48 -0500
Date: Sun, 2 Dec 2007 15:11:18 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071202141117.GB9516@lazybastard.org>
References: <20071130183510.GA1570@lazybastard.org> <20071130184625.GB9928@elte.hu> <20071201151650.GA5031@lazybastard.org> <20071201183256.GA14052@elte.hu> <20071201204747.GA6458@lazybastard.org> <20071201205456.GA8231@elte.hu> <20071201234112.GA7209@lazybastard.org> <20071202085607.GA28966@elte.hu> <20071202113143.GA9378@lazybastard.org> <20071202135711.GA20434@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071202135711.GA20434@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 December 2007 14:57:11 +0100, Ingo Molnar wrote:
> 
> hm, do you have CONFIG_FRAME_POINTERS=y, i.e. are the dumps reliable?

I do.  Went through 10odd runs and annotated the function right below
mcount each time.  Seems to work now.

Trouble is that it doesn't solve my real problem at hand.  Something is
causing significant delays when writing to logfs.  Core logfs code is
not running, but may cause whatever other code is running and burning up
all the cpu time.  Wasting 100ms of "qemu-time" to write a single page
happens fairly frequently.

With the latency tracer the problem appears to have become worse.  Now
the loftlockup code triggers quite frequently.  Which makes a bit of
sense, as the problem is a busy CPU, rather than an idle one.

Guess I'll try oprofile or lcov instead.

Jörn

-- 
Joern's library part 5:
http://www.faqs.org/faqs/compression-faq/part2/section-9.html
