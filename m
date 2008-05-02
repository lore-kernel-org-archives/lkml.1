Return-Path: <linux-kernel-owner+w=401wt.eu-S933845AbYEBLvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845AbYEBLvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758864AbYEBLvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:51:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34658 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbYEBLvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:51:06 -0400
Subject: Re: Horrendous Audio Stutter - current git
From: Peter Zijlstra <peterz@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200805021345.17179.elendil@planet.nl>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <200805021337.10809.elendil@planet.nl> <1209728372.13978.147.camel@twins>
	 <200805021345.17179.elendil@planet.nl>
Content-Type: text/plain
Date: Fri, 02 May 2008 13:51:03 +0200
Message-Id: <1209729063.13978.152.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 13:45 +0200, Frans Pop wrote:
> On Friday 02 May 2008, Peter Zijlstra wrote:
> > On Fri, 2008-05-02 at 13:37 +0200, Frans Pop wrote:
> > > On Friday 02 May 2008, Peter Zijlstra wrote:
> > > > > Ok, that's _WAY_ too big, something went seriously wrong. Thanks!
> > > >
> > > > In fact, that is exactly 1024 time too large.
> > > >
> > > > How does this work for you:
> > >
> > > Changes nothing. Values of bonus_max are unchanged and still skips.
> >
> > Humm, I saw some bonus_max spikes on my laptop which were fixed by that
> > patchlet, ah well, the hunt goes on.
> 
> Oh! Hang on. I just checked and saw that I made the change in 
> dequeue_entity() instead of enqueue_entity(). Let me try again.
> 
> For code symmetry I guess both should probably be changed?

Symetry would actually make it something like:

enqueue()
  A
  B
  C

dequeu()
  C
  B
  A

But I just quickly checked the code and I can't see any ill effect of
mis-placing that code in dequeue() too.



