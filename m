Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbYJMP3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbYJMP3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbYJMP2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:28:52 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:51881 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961AbYJMP2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:28:51 -0400
Date: Mon, 13 Oct 2008 17:28:52 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make ATNGW100 serial ports configurable
Message-ID: <20081013172852.393584be@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <48F35F50.3000704@control.lth.se>
References: <48EF6762.2080205@control.lth.se>
	<20081010165814.1c62eabf@hskinnemo-gx745.norway.atmel.com>
	<48EF7949.4010108@control.lth.se>
	<20081013122727.7298bd4a@hskinnemo-gx745.norway.atmel.com>
	<48F32899.5000006@control.lth.se>
	<20081013143447.5e0519b3@hskinnemo-gx745.norway.atmel.com>
	<48F3473E.6070305@control.lth.se>
	<20081013153318.7ed8e8d8@hskinnemo-gx745.norway.atmel.com>
	<48F35F50.3000704@control.lth.se>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Oct 2008 15:28:36.0184 (UTC) FILETIME=[5C0A3D80:01C92D48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anders Blomdell <anders.blomdell@control.lth.se> wrote:
> Haavard Skinnemoen wrote:
> > Really? I personally think out-of-tree modules is a real hassle causing
> > extra work each time I need to update the kernel, whether it's on my
> > embedded target or my PC.
> Depends on if it's you or somebody else (who doesn't care about your code) that
> rebuilds the kernel. Since I plan to use some tens of atngw100's eventually,
> with at least 3 different expansions boards, a solution that doesn't need 3
> different kernels (i.e. loadable modules) is much preferred to a Kconfig (I know
> I started out with this, but one does change opinion :-) occasionally) or
> in-tree init code.

So what you really need is device tree support.

I suppose modules would do the trick in your case, but it sounds like a
very specialized setup, and I don't feel too good about bloating the
kernel for everyone else just to support this kind of thing.

Device tree support would probably make the kernel bigger too, but I
think that would be mostly __init code, so it doesn't matter as much.

> > Have a look at the EVKLCD10x code that was just applied for an example
> > of how to add support for an expansion board:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/hskinnemoen/avr32-2.6.git;a=commitdiff;h=a3bee42f058c2f9fe281df942eff397924630a12
> > 
> > Most of it is LCD-related, so if you only need to add a USART, you'll
> > only need a fraction of the code.
> I see a distinct clutter in setup.c (#ifndef CONFIG_BOARD_ATNGW100_EVKLCD10X)
> :-) (it clearly shows the need for conflict resolution, though)

Yes, but it's hard to avoid that, it's confined to the support code
for that particular expansion board, and the clutter is there to
support actual variations of the board. It could have been moved into
separate files, but that would have led to more duplication.

It's all about finding the right balance, really.

I didn't quite understand what you mean by "conflict resolution".

> > Also note that it shows a huge problem with the Kconfig approach: Most
> > devices need additional board-specific data. And even though the USART
> > doesn't currently need any of that, it may in the future when we add
> > support for RS485, hardware flow control, etc. How will you deal with
> > that through Kconfig?
> Honestly, I don't know :-(, but it would be nice to be able to select all these
> options wihout having to write the code myself :-)

But is wading through several dozen config options really that much
easier than writing ten lines of code?

> Question is if there is any way to come up with a solution that makes it
> possible to select software modules for what is present on a specific expansion
> board, my naive thought was that it should be selected by Kconfig (and in that
> vein, my 5 cents is that video for ngw100/stk100x should be selected as
> TCG057QVLAD/PH320240T/LTV350QV, and not as a by-product of selecting a specific
> expansion board, this way it would be easier to add video to a custom expansion
> board withou dragging in unrelated functions like USARTs). Perhaps it is
> possible to solve my problems as well as the stk100x clutter if it is done right?

Possibly. But adding options for the USARTs is only solving a tiny part
of the problem, and I'm worried that solving the rest in the same
manner is going to end up as a spectacular mess. If you can prove me
wrong, I'm all for it.

Haavard
