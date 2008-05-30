Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbYE3Qrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbYE3Qrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbYE3Qrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:47:42 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:35861 "EHLO
	outbound4-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbYE3Qrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:47:41 -0400
X-BigFish: VPS-37(zz1432R98dR7efV1805Mzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K1OXAZ-02-1K1-01
Date: Fri, 30 May 2008 10:48:39 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: David Brigada <brigad@rpi.edu>, Ingo Molnar <mingo@elte.hu>,
       Wim Van Sebroeck <wim@iguana.be>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Samuel Tardieu <sam@rfc1149.net>,
       Mike Frysinger <vapier.adi@gmail.com>, Mingarelli@infomag.amd.com
Subject: Re: drivers/watchdog/geodewdt.c: build fix
Message-ID: <20080530164839.GA13959@cosmic.amd.com>
References: <20080525100944.GA4084@infomag.infomag.iguana.be> <20080530150250.GA21945@elte.hu> <20080530153919.GC12123@cosmic.amd.com> <48402334.3000809@rpi.edu> <20080530160505.GA12722@cosmic.amd.com> <20080530162442.GB16164@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530162442.GB16164@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 30 May 2008 16:46:52.0031 (UTC) FILETIME=[C2CDA0F0:01C8C274]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/08 12:24 -0400, Lennart Sorensen wrote:
> On Fri, May 30, 2008 at 10:05:05AM -0600, Jordan Crouse wrote:
> > I think the hamster dropping code is queued for 2.6.27, so at least we're
> > up to mammals.
> > 
> > The story here is that in an unfortunate instance of bad planning the
> > MFGPT timers can only be configured once, so a module can't allocate a
> > timer at init and release it when it is done.  The original object of this
> > code was to try give the timer back to a module if it happened to go away
> > and come back, but that is clearly a more complex process then just simply
> > storing the module name, and this code fell into bitrot.
> 
> It is a bit unfortunate that someone decided to design 'configure once'
> hardware.  What were they thinking?

Agreed, very sub-optimal.   For all those prospective silicon vendors out
there, this is a good lesson.  Always let your software people review
the specification before you freeze the RTL - it will save you grief in
the long run. </sermon>

> I run a watchdog using the mfgpt, and I simply tore out the code that
> prevents reuse of the timers, and I decided which timers I am going to
> use for which purpose and never reuse them for anything else, so the
> parts of the configuration in the hardware that is fixed isn't an issue
> then.  I start the watchdog from grub, so I had to override the check
> when the kernel takes over the timer watchdog management after all.

I expect that this will be the primary usage model - every platform needs to
have a gentleman's agreement for how the timers are allocated and used.

> > So its not so much that we need to drop module support, rather it needs to
> > be understood that if you remove and insert your module on a regular basis
> > you will run out of timers, and deprive others of the timers too. I think
> > that is a reasonable restriction to impose, given the limited usefulness 
> > of these timers for general purpose use.
> 
> They are useful timers, but yes perhaps not for general purpose.  As a
> source of interrupts at certain intervals or as a watchdog they are not
> too bad.

For the longest time, I thought they were only good as a watchdog or
driving an external output.  I had to eat some crow when we figured out
that we could use them as the tick source for tickless, so I no longer say
that they won't be good for anything else, but their usefulness is
certainly limited.

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

