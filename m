Return-Path: <linux-kernel-owner+w=401wt.eu-S1758138AbZANCAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138AbZANCAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZANCAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:00:43 -0500
Received: from mail.suse.de ([195.135.220.2]:48006 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbZANCAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:00:42 -0500
Date: Wed, 14 Jan 2009 03:00:40 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: next-20090107: WARNING: at kernel/sched.c:4435 sub_preempt_count
Message-ID: <20090114020040.GA19806@wotan.suse.de>
References: <4966897E.5020302@free.fr> <f19298770901090209m7076f3afyd1e01e0fc9bbca59@mail.gmail.com> <20090111024945.GC7077@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111024945.GC7077@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 03:49:45AM +0100, Ingo Molnar wrote:
> 
> * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> 
> > One more instance of http://marc.info/?l=linux-kernel&m=123134586202636&w=2
> > Added Ingo Molnar to CC.
> 
> added Nick on Cc:. Nick, it's about:
> 
> > commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
> > Author: Nick Piggin <nickpiggin@yahoo.com.au>
> > Date:   Tue Sep 30 20:50:27 2008 +1000
> >
> >    sched: improve preempt debugging
> 
> causing a seemingly spurious warning.

I don't know how it is spurious... Presumably the sequence _would_ have
caused preempt count to go negative if the bkl were not held...

__do_softirq does a __local_bh_disable on entry, and it seems like the
_local_bh_enable on exit is what causes this warning. So something is
unbalanced somehow. Or is it some weird thing we do in early boot that
I am missing?

Can you put in some printks around these functions in early boot to
get an idea of what preempt_count is doing?



