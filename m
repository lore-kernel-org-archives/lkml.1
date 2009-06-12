Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZFLWbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZFLWbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZFLWbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:31:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57479 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZFLWbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:31:47 -0400
Date: Sat, 13 Jun 2009 00:31:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Ian Molton <ian@mnementh.co.uk>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090612223141.GF17688@elf.ucw.cz>
References: <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com> <20090610213710.GA8472@elf.ucw.cz> <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com> <20090612150504.GA15084@elf.ucw.cz> <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com> <4A32D079.9030707@mnementh.co.uk> <a55d774e0906121527n16019225q81084945a38bb97e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0906121527n16019225q81084945a38bb97e@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-06-12 15:27:01, Brian Swetland wrote:
> On Fri, Jun 12, 2009 at 3:02 PM, Ian Molton<ian@mnementh.co.uk> wrote:
> > Brian Swetland wrote:
> >
> >> Yup.  It's an HTC specific thing -- some of their devices don't have a
> >> battery gauge IC and estimate current drain based on hints provided to
> >> the baseband from the apps processor.  I'm not particularly thrilled
> >> with the interface, but without it the battery level estimation is
> >> flakier.
> >
> > Is there a reason that this couldnt be done in userspace?
> 
> It'd be a lot more overhead -- in some cases it's updated with
> relatively fine granularity (wifi driver changing state, backlight
> changing, etc), and on the kernel side it's just updating a shared
> memory location with the current estimate.  Userspace doesn't
> necessarily have the visibility into driver state to update it
> accurately, and punching that information down to userspace and then
> having userspace feed it back up to the kernel seems like more
> overhead and code to maintain to me.

Actually I agree with Brian here, this is better done at kernel level.

OTOH, at least initially, it does not need to be done at all. It will
make battery readings less reliable but hey... the battery meter does
not work reliably anyway and estimating capacity left from voltage
acceptably on other platforms...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
