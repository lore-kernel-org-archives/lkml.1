Return-Path: <linux-kernel-owner+w=401wt.eu-S934370AbYEUMrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370AbYEUMrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762565AbYEUMre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:47:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45024 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761279AbYEUMrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:47:33 -0400
Date: Wed, 21 May 2008 08:47:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Galbraith <efault@gmx.de>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24.7-rt8
In-Reply-To: <1211351104.5484.13.camel@marge.simson.net>
Message-ID: <Pine.LNX.4.58.0805210845090.13661@gandalf.stny.rr.com>
References: <1211258763.14697.82.camel@localhost.localdomain>
 <1211351104.5484.13.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 21 May 2008, Mike Galbraith wrote:
> On Tue, 2008-05-20 at 00:46 -0400, Steven Rostedt wrote:
> > We are pleased to announce the 2.6.24.7-rt8 tree, which can be
> > downloaded from the location:
> >
> >   http://rt.et.redhat.com/download/
>
> I ran mysql+oltp (ro) on 2.6.24.7-rt7 and 2.6.25-rt2 to compare
> throughput to their parent trees, and ended up with strange (and
> verified) looking performance curves for both trees.  The changes in
> 2.6.24.7-rt8 and 2.6.25.4-rt3 cured the primary oddities.

The difference between 24-rt7 and 24-rt8 as well as with 25-rt2 and 25-rt3
is the deserialization of rwlocks. The rt patch as always serialized
readers to allow for priority inheritance with rwlocks. I wrote a patch to
break that and allow for multiple readers and still keep the priority
inheritance.

Your test probably had a bottle neck on a rwlock (same for rwsems)
somewhere that the new code solved.

-- Steve
