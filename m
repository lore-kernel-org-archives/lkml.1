Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZEWUPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZEWUPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 16:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbZEWUPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 16:15:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58966 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbZEWUPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 16:15:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kim Kyuwon <chammoru@gmail.com>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
Date: Sat, 23 May 2009 22:14:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Kyungmin Park <kyungmin.park@samsung.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com> <200905230029.18279.rjw@sisk.pl> <4d34a0a70905221603g785f5b78h330249ff258dbfdd@mail.gmail.com>
In-Reply-To: <4d34a0a70905221603g785f5b78h330249ff258dbfdd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905232214.57186.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 May 2009, Kim Kyuwon wrote:
> On Sat, May 23, 2009 at 7:29 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday 23 May 2009, Kim Kyuwon wrote:
[--snip--]
> >> You changed the really important part of Linux, which may affect most
> >> processor architectures. I think you should be careful. If some of
> >> architectures can't take care of it (they can implement
> >> disable_irq_wake correctly in H/W level, will you revert your changes?
> >
> > No, the changes are not going to be reverted.  In fact things should have been
> > done like this already much earlier.
> >
> > Now, do you have any particular example of a problem related to these changes
> > or is it only a theoretical issue?
> 
> I'd CCing you when I'm sending a mail for this particular example of a example.
> http://markmail.org/thread/fvt7d62arofon5xx

Well, as I said above, reverting the changes that introduced
[suspend|resume]_device_irqs() is not an option, becuase it was the only sane
way to achieve the goal they were added for.  So, we need to fix the wake-up
problem on your platform with the assumption that
[suspend|resume]_device_irqs() are going to stay.

For starters, would it be possible to teach the 'disable' hook of your
platform's interrupt controller not to mask the IRQs that have both
IRQ_WAKEUP and IRQ_SUSPENDED set?  That apparently would work around the
wake-up interrupts problem.

Best,
Rafael
