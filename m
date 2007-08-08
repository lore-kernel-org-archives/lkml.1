Return-Path: <linux-kernel-owner+w=401wt.eu-S934071AbXHHODF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071AbXHHODF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759435AbXHHOCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:02:51 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:55561 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbXHHOCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:02:50 -0400
Date: Wed, 8 Aug 2007 10:01:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in
 entry.S
In-Reply-To: <20070808132926.GC14419@one.firstfloor.org>
Message-ID: <Pine.LNX.4.58.0708080952020.7744@gandalf.stny.rr.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
 <200708081138.23018.ak@suse.de> <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com>
 <200708081424.49896.ak@suse.de> <Pine.LNX.4.58.0708080835350.6751@gandalf.stny.rr.com>
 <p738x8mrv4m.fsf@bingen.suse.de> <Pine.LNX.4.58.0708080919330.7236@gandalf.stny.rr.com>
 <20070808132926.GC14419@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Wed, 8 Aug 2007, Andi Kleen wrote:

> > When I said "this part of the code I don't fully understand" I was not
> > talking about entry.S.  I understand entry.S very well, but the comment
> > was originally on the paranoid_restore code. Which I thought had to deal
> > with NMIs and such that I didn't worry about that I simply did the
> > default.
>
> The paranoid path is used for more than just NMIs; it's also used for MCEs,
> stack faults, double faults or debug exceptions. Anything that might
> happen with a invalid stack or unknown GS state or system in other unknown
> state.
>
> If you can guarantee your hypervisor never injects any of those it could be ignored;
> but at least losing debug exceptions would be probably not nice.

For now it does ignore them. But that's something to work on
for later versions of lguest64.  I want lguest out in the public and
working for the general case. I don't plan on ignoring the paranoid
section forever. But it's more on an anomaly for now. But you are right, I
want the debug stuff working. But I also need to walk before I can run ;-)


>
> >
> > >>  paranoid_restore\trace:
> > >>       RESTORE_ALL 8
> > >> -     iretq
> > >> +     INTERRUPT_RETURN
> > >
> > >I suspect Xen will need much more changes anyways because of its
> > >ring 3 guest. Are these changes sufficient for lguest?
>
> This was really a general comment not especially applying to the
> paranoid path.

Ah, OK, I assumed you were talking about just the previous code. But
rereading your post, I see it was more general.  Sorry, for the
miscommunication.

-- Steve

