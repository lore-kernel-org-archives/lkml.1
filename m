Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYCNTfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYCNTfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYCNTfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:35:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59631 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYCNTfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:35:10 -0400
Date: Fri, 14 Mar 2008 20:35:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: David Newall <davidn@davidnewall.com>, Jiri Kosina <jkosina@suse.cz>,
       "Fred ." <eldmannen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
Message-ID: <20080314193534.GB24646@elf.ucw.cz>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz> <47D7B428.6010804@davidnewall.com> <20080313171425.GA4840@ucw.cz> <20080314133019.GE1289@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314133019.GE1289@csclub.uwaterloo.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-03-14 09:30:19, Lennart Sorensen wrote:
> On Thu, Mar 13, 2008 at 06:14:26PM +0100, Pavel Machek wrote:
> > hw is proper place to implement autorepeat, and along with some
> > buffering, it has chance to work. Kernel is not real-time, and X are
> > definitely not real-time, while autorepeat is real-time operation.
> > 
> > It actually mostly works in ps/2 case. Buffer in hardware means that
> > pretty big interrupt delays can be tolerated without problems.
> 
> So does the keyboard events generate something like this then:
> 
> KEY_x_DOWN
> KEY_x_REPEAT
> KEY_x_UP

Yes, kernel<->user interface is something like that. Try evtest to see
it.

> If so then X certainly could get all the keyboard information I imagine
> it needs from the kernel, but otherwise I am not sure how it could.
> A
> repeated series of key down events are not enough since some keys you
> don't want repeated you just want to know when the key is held down and
> when it isn't.

PS/2 keyboard sends both ups and downs. "down down down up" means
autorepeat. It is not actually ambiguous.

BTW this is what I use to generate huge latencies and cause X
problems:

void
main(void)
{
        int i;
        iopl(3);
        while (1) {
                asm volatile("cli");
                //              for (i=0; i<20000000; i++)
                for (i=0; i<1000000000; i++)
                        asm volatile("");
                asm volatile("sti");
                sleep(1);
        }
}

...run it once per core.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

