Return-Path: <linux-kernel-owner+w=401wt.eu-S1763339AbZCYSl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763339AbZCYSl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZCYSlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:41:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39592 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZCYSlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:41:20 -0400
Date: Wed, 25 Mar 2009 14:41:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tim Bird <tim.bird@am.sony.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: Anyone working on ftrace function graph support on ARM?
In-Reply-To: <49CA79FA.8080906@am.sony.com>
Message-ID: <alpine.DEB.2.00.0903251440320.5675@gandalf.stny.rr.com>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere> <20090325084248.GF4697@n2100.arm.linux.org.uk> <49CA5CFF.8090908@am.sony.com> <20090325170533.GA4667@pengutronix.de>
 <20090325171727.GH2952@n2100.arm.linux.org.uk> <49CA79FA.8080906@am.sony.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Tim Bird wrote:

> Russell King - ARM Linux wrote:
> > On Wed, Mar 25, 2009 at 06:05:33PM +0100, Uwe Kleine-K???nig wrote:
> >> On Wed, Mar 25, 2009 at 09:34:07AM -0700, Tim Bird wrote:
> >>> Russell King - ARM Linux wrote:
> >>>> As pointed out in my previous mail, identifying where on the stack the
> >>>> return address is stored is only possible for OABI with frame pointers.
> >>>>
> >>>> EABI will probably be possible with the stack unwinding code, but it
> >>>> probably won't be cheap.  The EABI unwinder is scheduled for merging
> >>>> during the present now-open merge window.
> >> EABI with frame pointers should work, too, shouldn't it?
> > 
> > Yes, as I said at the top of my reply dated Wed, 25 Mar 2009 09:57:51 +0000
> 
> It turns out you can't use -pg and -fomit-frame-pointers at the same time.
> At least, my gcc complains about this:
> $ make
> arm-sony-linux-gnueabi-dev-gcc -g -pg -fomit-frame-pointer -o hello hello.c
> arm-sony-linux-gnueabi-dev-gcc: -pg and -fomit-frame-pointer are incompatible
> make: *** [hello] Error 1

Correct, that is because mcount requires (as Russell earlier pointed out) 
the use of frame pointers.

-- Steve

