Return-Path: <linux-kernel-owner+w=401wt.eu-S934039AbXIKVZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039AbXIKVZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763668AbXIKVZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:25:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763510AbXIKVZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:25:02 -0400
Date: Tue, 11 Sep 2007 14:24:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 merge - a little feedback
In-Reply-To: <1189542314.5235.48.camel@chaos>
Message-ID: <alpine.LFD.0.999.0709111421200.16478@woody.linux-foundation.org>
References: <20070911201219.GA9674@uranus.ravnborg.org>
 <1189542314.5235.48.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 Sep 2007, Thomas Gleixner wrote:
> 
> I tried to unify the Makefile by using 
> 
> obj-$(CONFIG_X86_32) += ....
> and
> obj-$(CONFIG_X86_64) += ....

Don't do that.

I think it would be much better to instead do something like

	obj-y += mmconfig_$(CONFIG_WORD_SIZE).o

to make it clear when we have a file that is conceptually the same, but 
has different implementations.

That also makes the unification (assuming/hoping it gets done) of such 
files much cleaner - you just merge them, and the obj-y line can just drop 
the $(CONFIG_WORD_SIZE) thing. Very logical.

> but I did fail due to link order problems in that code.

.. the above approach also gets rid of any link order problems.

			Linus
