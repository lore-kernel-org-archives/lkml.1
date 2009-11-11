Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbZKKNXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbZKKNXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 08:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZKKNXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 08:23:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50985 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbZKKNXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 08:23:09 -0500
Subject: Re: Hard lockup with timer events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, acme@redhat.com, rosted@goodmis.org,
       paulus@samba.org
In-Reply-To: <20091111045004.GA5421@nowhere>
References: <ye8hbtiko5k.fsf@camel23.daimi.au.dk>
	 <20091111045004.GA5421@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 11 Nov 2009 14:23:01 +0100
Message-ID: <1257945781.4372.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 05:50 +0100, Frederic Weisbecker wrote:
> On Thu, Oct 29, 2009 at 08:15:03PM +0100, Soeren Sandmann wrote:
> > Hi,
> > 
> > This program
> > 
> >         http://www.daimi.au.dk/~sandmann/lockup.c
> > 
> > locks up hard for me on a Pentium 4 in 32 bit mode, with the hrtimer
> > patches applied (-tip for example).
> > 
> > What the program does is spawn a thread that just spins, and then 400
> > threads that each create a performance counter of type
> > PERF_COUNT_SW_CPU_CLOCK and a sample period of 1000000 and a
> > sample_type of
> > 
> >         PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_CALLCHAIN
> > 
> > These threads then map the event buffer and read it continuously.
> > 
> > It does not apparently lock up if SAMPLE_CALLCHAIN is removed; also I
> > cannot get it to lock up on Core 2 Duo in either 32 or 64 bit mode.
> > 
> > 
> > Soren
> 
> 
> 
> It locks up hard for me too, no more blinking cursor, nothing.
> I've attached my config, it's against tip:master from yesterday.

What kind of cpu does your laptop have? The .config seems to suggest a
Core2. Which would make Soeren's report of not being able to trash a
64bit core2 'interesting' ;-)
