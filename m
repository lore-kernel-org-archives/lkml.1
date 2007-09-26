Return-Path: <linux-kernel-owner+w=401wt.eu-S1761034AbXIZUqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761034AbXIZUqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbXIZUqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:46:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40344 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbXIZUqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:46:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [REGRESSION from 2.6.23-rc8] (was: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents)
Date: Wed, 26 Sep 2007 23:00:27 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200709231257.12213.rjw@sisk.pl> <1190832665.23376.38.camel@chaos> <200709262149.54732.rjw@sisk.pl>
In-Reply-To: <200709262149.54732.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709262300.28336.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 26 September 2007 21:49, Rafael J. Wysocki wrote:
> On Wednesday, 26 September 2007 20:51, Thomas Gleixner wrote:
> > On Wed, 2007-09-26 at 17:25 +0200, Rafael J. Wysocki wrote:
> > > There still are some oddities.
> > > 
> > > First, with the "x86-64: Disable local APIC timer use on AMD systems with C1E"
> > > patch and my collection of suspend patches applied, the box doesn't boot
> > > (the suspend patches don't even thouch the boot code, so they should be
> > > irrelevant here).  However, it boots if patch-2.6.23-rc7-hrt1.patch (adjusted
> > > for 2.6.23-rc8) is applied in addition.  Is this expected?
> > 
> > No. That's odd. It is nothing else than adding "noapictimer" to the
> > kernel command line.
> 
> Seems to be reproducible, though.  I'll investigate further.

So far, the results are the following:

1) current Linus' tree doesn't boot with any command line (regression)

[  Linus, please revert commit e66485d747505e9d960b864fc6c37f8b2afafaf0

   x86-64: Disable local APIC timer use on AMD systems with C1E

   It's not necessary for 2.6.23 and actually kills the box that it's supposed to fix. ]

2) 2.6.23-rc8 w/ the "x86-64: Disable local APIC timer use on AMD systems with C1E"
   patch applied behaves like the current -git

3) 2.6.23-rc8 w/o this patch doesn't boot with either "noapictimer" _or_
   "apicmaintimer"

4) 2.6.22 behaves like 2.6.23-rc8

5) 2.6.23-rc8 with (adjusted) patch-2.6.23-rc7-hrt1.patch boots only with
   "noapictimer"

6) 2.6.23-rc8 with (adjusted) patch-2.6.23-rc7-hrt1.patch and with the
   "x86-64: Disable local APIC timer use on AMD systems with C1E" patch boots
   without any extra command line options

Tested for a couple of times with each kernel, the results seem to be
reproducible 100% of the time.

Greetings,
Rafael
