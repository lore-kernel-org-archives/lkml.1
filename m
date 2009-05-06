Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZEFIEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZEFIEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbZEFIDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:03:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZEFIDn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:03:43 -0400
Subject: Re: CFS not suitable for desktop computers
From: Peter Zijlstra <peterz@infradead.org>
To: Nico =?ISO-8859-1?Q?Sch=FCmann?= <spam@nico22.de>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
In-Reply-To: <49FF06D0.80109@nico22.de>
References: <49FDEFD1.8020608@nico22.de>
	 <1241424835.26855.102.camel@marge.simson.net>  <49FF06D0.80109@nico22.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 May 2009 10:03:40 +0200
Message-Id: <1241597020.11251.82.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-04 at 17:16 +0200, Nico Schümann wrote: 
> Thank you Ray Lee and Mike Galbraith for your responses, I ran the 
> script and attached its gathered information.
> 
> Mike Galbraith wrote:
> > How hard is hard?  Can you describe the loads you're having trouble
> > with, and the hardware you're running them on?
> >
> >   
> I could reproduce "hard" load by just compiling the linux kernel, make 
> -j3 while reading mails with Thunderbird, which is not that hard 
> foreground load. Thunderbird starts reacting really slowly while compiling.

Right, such a load will leave your thunderbird about 25% of the cpu. I
think its fair to expect it to be slower, but it should still be
workable.

I used to test CFS on my 1.2GHz laptop with 512M and a make -j5. That
would result in a slow but steady system. With steady I mean the latency
was pretty constant.

The O(1) scheduler would utterly mess this up, it would be fast, until
the desktop bloat took enough cpu time and then it would starve a while,
etc..

The thing is, we really cannot go about guessing, its too easy to guess
wrong. If you know its a background task, nice it.

alias make='nice make'

and you're done.
