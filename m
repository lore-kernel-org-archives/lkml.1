Return-Path: <linux-kernel-owner+w=401wt.eu-S1161575AbXDYB3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161575AbXDYB3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 21:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161823AbXDYB3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 21:29:08 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:40792 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161575AbXDYB3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 21:29:06 -0400
Date: Tue, 24 Apr 2007 21:29:01 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Mark Hull-Richter <mhullrich@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel traces coming back with trash/clutter
In-Reply-To: <f4e013870704241701y748cd32esfd8dd79658797320@mail.gmail.com>
Message-ID: <alpine.DEB.0.98.0704242121140.30003@sigma.j-a-k-j.com>
References: <f4e013870704241640q5a723664l2fda780a24f9b40e@mail.gmail.com> 
 <alpine.DEB.0.98.0704241944270.26721@sigma.j-a-k-j.com>
 <f4e013870704241701y748cd32esfd8dd79658797320@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I am getting this odd content in the trace log (dmesg), and I cannot
> > > figure out what it is or why it is there.
> > >
> > > <7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
> > > <7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
> > > <7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
> > > <7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7><7>
> > > <7><7><7><7><7>__bio_add_page: 2x ph 88>=128 || hw 88>=88 || 360448>max
> > > ffffffff802525d8 generic_make_request(bio 000001017c745300) 50729472, 704
> > 
> > Perhaps you have something looping that's outputting KERN_DEBUG with a
> > null message? Or one of your diagnostic printk statements includes
> > KERN_DEBUG with no actual message?
> > 
> No, they are all KERN_DEBUG<space>"some string here", almost all with
> some formatted output as well.  Could I be overloading the printk
> output buffer, as in possibly too tightly repeated/looped code to be
> able to output it all?

It is possible, I suppose. Is what you're working on open-source? If so, 
you could send it to me and I could try and reproduce it here and track it 
down. If you want me to, that is. (If you do send, please include a 
".config".)

Otherwise, I couldn't tell you what it might be. Make sure all your 
messages end with '\n', make sure you're not accidentally using the wrong 
formatting codes and it's backing over previous output with ^H or 
something. You could confirm or rule out the possibility of overflowing 
the printk buffers by writing a dummy module with a tight loop of nothing 
but printk statements with counters to see if you can get it to asplode.
