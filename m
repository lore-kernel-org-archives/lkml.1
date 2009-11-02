Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbZKBJ3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbZKBJ3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 04:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZKBJ3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 04:29:11 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:59641 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbZKBJ3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 04:29:11 -0500
Date: Mon, 2 Nov 2009 10:29:09 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, dsaxena@laptop.org, alan@linux.intel.com,
       gregkh@suse.de, linux-arm-kernel@lists.infradead.org,
       Eric <eric.y.miao@gmail.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, dbaryshkov@gmail.com, omegamoon@gmail.com,
       utx@penguin.cz, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Possible suspend/resume regression in .32-rc?
Message-ID: <20091102092909.GW14091@buzzloop.caiaq.de>
References: <20091031013427.GL14091@buzzloop.caiaq.de>
 <20091101205449.GT14091@buzzloop.caiaq.de>
 <20091101213343.GA31345@elf.ucw.cz>
 <20091101220341.GA16698@elf.ucw.cz>
 <771cded00911020122o3bb5cc96q957c8be1ce7cae46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <771cded00911020122o3bb5cc96q957c8be1ce7cae46@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 05:22:30AM -0400, Haojian Zhuang wrote:
> >> > Ok, got it. The culprit is commit d2c37068 ("[ARM] pxa: initialize
> >> > default interrupt priority and use ICHP for IRQ handling"). Reverting it
> >> > make suspend/resume work again on my board.
> >> >
> >> > Haojian, Eric, could you have a look at this?
> >>
> >> Okay, patch is this one: I'll test reverting it shortly.
> >>
> >> commit d2c37068429b29d6549cf3486fc84b836689e122
> >> Author: Haojian Zhuang <haojian.zhuang@marvell.com>
> >> Date:   Wed Aug 19 19:49:31 2009 +0800
> >>
> >>     [ARM] pxa: initialize default interrupt priority and use ICHP for IRQ handling
> >>
> >>     Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
> >>     Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
> >
> > And yes, reverting it _does_ fix suspend on spitz.
> >
> >                                                                        Pavel
> 
> Em, it's not caused by the IRQ patch.
> 
> The kernel is blocked in resume path. When console is resumed, IRQ is
> already disabled and system is blocked. Actually, IRQ shouldn't be
> disabled at here. Up to now, I only find which patch will cause this
> issue. But I can't find the best solution on it. The patch with issue
> is pasted in below.
> 
> So this issue is only occused when console suspend is enabled. If you
> enable no_console_suspend in command, you won't meet this issue. It
> seems that it's caused by removing termios setting in
> uart_resume_port() in the below patch. If I add these code back, the
> issue doesn't occur any more.

Well no, not confirmed. I tested with no_console_suspend, and it still
hit me. And without too, btw.

Daniel
