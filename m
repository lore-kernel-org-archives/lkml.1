Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYINP7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYINP7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYINP7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:59:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3248 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752738AbYINP7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:59:43 -0400
Date: Sun, 14 Sep 2008 17:59:29 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apci: dump slit
Message-ID: <20080914155928.GB4845@ucw.cz>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com> <20080912122031.eca8723e.akpm@linux-foundation.org> <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com> <878wtxrrwh.fsf@basil.nowhere.org> <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de> <20080914112222.GA3956@ucw.cz> <20080914122618.GD16097@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914122618.GD16097@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-09-14 14:26:18, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@suse.cz> wrote:
> 
> > On Fri 2008-09-12 23:19:21, Thomas Gleixner wrote:
> > > On Fri, 12 Sep 2008, Andi Kleen wrote:
> > > > "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> > > > >
> > > > > to see how wrong could be set by BIOS.
> > > > 
> > > > Just dump it from user space then.  There are plenty of tools
> > > > to access ACPI tables.
> > > 
> > > 1.) what guarantees that we reach user space ?
> > 
> > We can dump in *any* kernel.
> >
> > > 2) If it is _valuable_ information which we can gather via kernel
> > >    output, then it is much more conveniant than asking the user to type
> > >    whatevercryptictoolcommandline and provide the output.
> > 
> > Ooh, 'lets dump more junk at everyone, typing commands is hard' :-(.
> 
> no, the principle is, information like the boot-time CPUID information 
> (and even the BIOS environment) can be indicative of _kernel bugs_. It 
> is often essential to dump what the booting (and failing) kernel thinks 
> is its environment.
> 
> Often that environment is corrupted (by the kernel) and that leads to 
> problems. This 'environment' can also be affected by things like hard 
> boot vs cold boot differences, whether it's in a kexec environment, 
> whether it's booted as a virtual guest, etc., etc.
> 
> For a long time we had the kernel's x86 bootup pretty much as a mostly 
> silent black box and when it broke we tried to figure things out 
> afterwards which was difficult and error-prone. Now we've got various 
> quite effective debug mechanisms (which includes printouts as well) and 
> figuring out x86 problems is visibly easier. We definitely wont go back 
> to the 'black box code, can only be debugged by a few experts' method.
> 
> So extending on that is a good and obvious idea in general - and i agree 
> with Peter that this should be command-line dependent, i.e. not printed 
> by default. Only printing it when 'debug' is specified on the command 
> line is a good solution.

Dumping when user requested it on commandline seems like good
compromise to me.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
