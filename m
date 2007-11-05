Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbXKEX6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbXKEX6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbXKEX6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:58:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754153AbXKEX6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:58:09 -0500
Date: Mon, 5 Nov 2007 15:57:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: peterz@infradead.org, just.for.lkml@googlemail.com,
       maximlevitsky@gmail.com, linux-kernel@vger.kernel.org, dgc@sgi.com,
       linux-fsdevel@vger.kernel.org
Subject: Re: writeout stalls in current -git
Message-Id: <20071105155749.73e0e38e.akpm@linux-foundation.org>
In-Reply-To: <393999615.15343@ustc.edu.cn>
References: <393056632.00561@ustc.edu.cn>
	<200710221505.35397.maximlevitsky@gmail.com>
	<20071022131045.GA5357@mail.ustc.edu.cn>
	<393060478.03650@ustc.edu.cn>
	<64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
	<393903856.06449@ustc.edu.cn>
	<64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	<64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	<E1InmAI-0003ME-2i@localhost>
	<1193998532.27652.343.camel@twins>
	<393999615.15343@ustc.edu.cn>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2007 18:33:29 +0800
Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> On Fri, Nov 02, 2007 at 11:15:32AM +0100, Peter Zijlstra wrote:
> > On Fri, 2007-11-02 at 10:21 +0800, Fengguang Wu wrote:
> > 
> > > Interestingly, no background_writeout() appears, but only
> > > balance_dirty_pages() and wb_kupdate.  Obviously wb_kupdate won't
> > > block the process.
> > 
> > Yeah, the background threshold is not (yet) scaled. So it can happen
> > that the bdi_dirty limit is below the background limit.
> > 
> > I'm curious though as to these stalls, though, I can't seem to think of
> > what goes wrong.. esp since most writeback seems to happen from pdflush.
> 
> Me confused too. The new debug patch will confirm whether emerge is
> waiting in balance_dirty_pages().
> 
> > (or I'm totally misreading it - quite a possible as I'm still recovering
> > from a serious cold and not all the green stuff has yet figured out its
> > proper place wrt brain cells 'n stuff)
> 
> Do take care of yourself.
> 
> > 
> > I still have this patch floating around:
> 
> I think this patch is OK for 2.6.24 :-)
> 
> Reviewed-by: Fengguang Wu <wfg@mail.ustc.edu.cn> 

I would prefer Tested-by: :(

> > 
> > ---
> > Subject: mm: speed up writeback ramp-up on clean systems
> > 
> > We allow violation of bdi limits if there is a lot of room on the
> > system. Once we hit half the total limit we start enforcing bdi limits
> > and bdi ramp-up should happen. Doing it this way avoids many small
> > writeouts on an otherwise idle system and should also speed up the
> > ramp-up.

Given the problems we're having in there I'm a bit reluctant to go tossing
hastily put together and inadequately tested stuff onto the fire.  And
that's what this patch looks like to me.

Wanna convince me otherwise?
