Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbXIZXcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbXIZXcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 19:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXIZXcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 19:32:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbXIZXcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 19:32:08 -0400
Message-ID: <46FAEBAC.1010603@redhat.com>
Date: Wed, 26 Sep 2007 19:30:52 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [REGRESSION from 2.6.23-rc8]
References: <200709231257.12213.rjw@sisk.pl>	 <1190832665.23376.38.camel@chaos> <200709262149.54732.rjw@sisk.pl>	 <200709262300.28336.rjw@sisk.pl> <1190842476.23376.57.camel@chaos>	 <alpine.LFD.0.999.0709261521440.3579@woody.linux-foundation.org> <1190846101.23376.64.camel@chaos>
In-Reply-To: <1190846101.23376.64.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2007 06:35 PM, Thomas Gleixner wrote:
> 
> It's even worse than I thought on the first check:
> 
> "noapictimer" on the command line of an SMP box prevents _ONLY_ the boot
> CPU apic timer from being used. But the secondary CPU is still
> unconditionally setting up the APIC timer and uses the non calibrated
> variable calibration_result, which is of course 0, to setup the APIC
> timer. Wreckage guaranteed.
> 

Well, that would explain a lot of the things I've been seeing...
