Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbXIYUqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbXIYUqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXIYUqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:46:36 -0400
Received: from www.osadl.org ([213.239.205.134]:54672 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750851AbXIYUqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:46:36 -0400
Subject: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325,
	related to clockevents
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200709252207.02532.rjw@sisk.pl>
References: <200709231257.12213.rjw@sisk.pl>
	 <200709251516.58405.rjw@sisk.pl> <1190726273.4035.331.camel@chaos>
	 <200709252207.02532.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 22:46:32 +0200
Message-Id: <1190753192.17409.62.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Tue, 2007-09-25 at 22:07 +0200, Rafael J. Wysocki wrote:
> On Tuesday, 25 September 2007 15:17, Thomas Gleixner wrote:
> > On Tue, 2007-09-25 at 15:16 +0200, Rafael J. Wysocki wrote:
> [--snip--]
> > 
> > I start to get desperate. Below is a patch, which moves the apic timer
> > disable check after the calibration routine. Can you please apply on top
> > of -hrt and add "noapictimer" to the command line ? Does it boot ?
>
> 2.6.23-rc7 with patch-2.6.23-rc7-hrt1.patch and the patch below applied boots
> with noapictimer and doesn't boot without it.

That was expected. I explicitly asked to add "noapictimer" to the kernel
command line.

Ok, so we ruled out the apic timer calibration routine. I did not expect
that this would be the culprit, but with "dark screen" as the only debug
info, I need to resort to small steps.

Can you please send me the output of /proc/timer_list of 2.6.23-rc7-hrt1
after booting with "noapictimer" ?

I'm a bit confused by your earlier confirmation, that mainline w/o the
-hrt patches boots fine, when you add "apicmaintimer" to the kernel
command line. "apicmaintimer" stops the PIT like we do in -hrt and we
just use the local APIC timer for everything. Can you please retest and
confirm that this is correct ?

Is the 32 bit kernel working on that box ?

Thanks for your patience.

	tglx

PS: I just sent out the "disable APIC timer for AMD C1E boxen" patch. We
debugged this half a year ago on a nx6325, but I completely forgot about
that. The explanation from AMD was sensible, but your "apicmaintimer"
works statement is contradictory.


