Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYKJMoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYKJMoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbYKJMoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:44:24 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:58389 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754773AbYKJMoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:44:23 -0500
Message-Id: <1226321061.23701.1283927805@webmail.messagingengine.com>
X-Sasl-Enc: yCiynDSJBZanTdAEK3cHQbQL3AQrVnbFehIxn1rJhDVG 1226321061
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lguest@ozlabs.org,
       jeremy@xensource.com, "Steven Rostedt" <srostedt@redhat.com>,
       "Mike Travis" <travis@sgi.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20081104122839.GA22864@mailshack.com> 
 <20081104150729.GC21470@localhost> 
 <20081104170501.GE29626@one.firstfloor.org> 
 <1225822006.21441.1282961299@webmail.messagingengine.com> 
 <20081104204400.GC10825@elte.hu> 
 <1226243805.27361.1283784629@webmail.messagingengine.com> 
 <20081110085846.GG22392@elte.hu>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
In-Reply-To: <20081110085846.GG22392@elte.hu>
Date: Mon, 10 Nov 2008 13:44:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008 09:58:46 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> > Hi all,
> > 
> > I have spent some time trying to find out how expensive the 
> > segment-switching patch was. I have only one computer available at 
> > the time: a "Sempron 2400+", 32-bit-only machine.
> > 
> > Measured were timings of "hackbench 10" in a loop. The average was 
> > taken of more than 100 runs. Timings were done for two seperate 
> > boots of the system.

Hi Ingo,

I guess you just stopped reading here?

> hackbench is _way_ too noisy to measure such cycle-level differences 
> as irq entry changes cause. It also does not really stress interrupts 
> - it only stresses networking, the VFS and the scheduler.
> 
> a better test might have been to generate a ton of interrupts, but 
> even then it's _very_ hard to measure it properly.

I should have presented the second benchmark as the first I
guess. I really just used hackbench as a workload. I gathered
it would give a good amount of exceptions like page faults and
maybe others. It would be nice to have a simple debug switch in
the kernel to make it generate a lot of interrupts, though ;).

>                    The best method is 
> what i've suggested to you early on: run a loop in user-space and 
> observe irq costs via RDTSC, as they happen. Then build a histogram 
> and compare the before/after histogram. Compare best-case results as 
> well (the first slot of the histogram), as those are statistically 
> much more significant than a noisy average.

See the rest of the mail you replied to and its attachment. I've put
the programs I used and the histogram in

http://heukelum.fastmail.fm/irqstubs/

I think rdtsctest.c is pretty much what you describe.

Greetings,
    Alexander

> Measuring such things in a meaningful way is really tricky business. 
> Using hackbench to measure IRQ entry micro-costs is like trying to 
> take a photo of a delicate flower at night, by using an atomic bomb as 
> the flash-light: you certainly get some sort of effect to report, but 
> there's not many nuances left in the picture to really look at ;-)
> 
> 	Ingo
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Same, same, but different...

