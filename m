Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZCBVRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZCBVRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZCBVR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:17:27 -0500
Received: from viefep20-int.chello.at ([62.179.121.40]:55807 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZCBVR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:17:26 -0500
X-SourceIP: 213.93.53.227
Subject: Re: lockdep and threaded IRQs (was: ...)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Brownell <david-b@pacbell.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
In-Reply-To: <200903021304.56881.david-b@pacbell.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	 <200903011454.22280.david-b@pacbell.net> <1235999772.5330.368.camel@laptop>
	 <200903021304.56881.david-b@pacbell.net>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 22:16:57 +0100
Message-Id: <1236028617.18955.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 13:04 -0800, David Brownell wrote:
> On Monday 02 March 2009, Peter Zijlstra wrote:
> > IRQF_DISABLED is bonkers,
> 
> Hmm, after all the work that's been done to get Linux
> to the point where *most* drivers run without IRQs
> enabled ... that sentiment surprises me.
> 
> And I suspect it would surprise most driver developers.

How so?, its the natural extension of that work.

> > we should simply always disable interrupts for 
> > interrupt handlers.
> 
> That would be why you have refused to fix the bug
> in lockdep, whereby it forcibly enables that flag?
> 
> I've been wondering for some months now why you've
> left that bug unfixed.

Because running irq handlers with irqs enabled it plain silly.

Except it turns out there is some really broken ass hardware out there.
But supposedly IDE PIO could be done from a threaded handler.



