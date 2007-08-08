Return-Path: <linux-kernel-owner+w=401wt.eu-S1762606AbXHHN2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606AbXHHN2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbXHHN20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:28:26 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:44805 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837AbXHHN2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:28:25 -0400
Date: Wed, 8 Aug 2007 09:26:50 -0400 (EDT)
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
In-Reply-To: <Pine.LNX.4.58.0708080919330.7236@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.58.0708080924590.7236@gandalf.stny.rr.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
 <200708081138.23018.ak@suse.de> <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com>
 <200708081424.49896.ak@suse.de> <Pine.LNX.4.58.0708080835350.6751@gandalf.stny.rr.com>
 <p738x8mrv4m.fsf@bingen.suse.de> <Pine.LNX.4.58.0708080919330.7236@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 8 Aug 2007, Steven Rostedt wrote:

> On Wed, 8 Aug 2007, Andi Kleen wrote:
>
> >>  paranoid_restore\trace:
> >>       RESTORE_ALL 8
> >> -     iretq
> >> +     INTERRUPT_RETURN
> >
> >I suspect Xen will need much more changes anyways because of its
> >ring 3 guest. Are these changes sufficient for lguest?
>
>
> The above was what I was replying to.

If you were talking about the general iretq => INTERRUPT_RETURN, then the
answer is "Yes, they are sufficient". The first version of lguest ran the
guest kernel in ring 3 (using dual page tables for guest kernel and guest
user).  The current version I'm pushing runs lguest in ring 1, and the
entry.S code  worked for both.

-- Steve

