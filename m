Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbYDTMsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbYDTMsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 08:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYDTMs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 08:48:27 -0400
Received: from 1wt.eu ([62.212.114.60]:3215 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbYDTMs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 08:48:27 -0400
Date: Sun, 20 Apr 2008 14:47:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420124717.GH8474@1wt.eu>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y778aezh.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 02:27:14PM +0200, Andi Kleen wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> >
> > 6k is known to work, and there aren't many problems known with 4k.
> >
> > And from a QA point of view the only way of getting 4k thoroughly tested 
> 
> But you have to first ask why do you want 4k tested? Does it serve
> any useful purpose in itself? I don't think so. Or you're saying
> it's important to support 50k kernel threads on 32bit kernels?

Clearly if I have the choice between a kernel which can run 50k threads
and a kernel which does not crash under me during an I/O error, I choose
the later! I don't even imagine what purpose 50k kernel threads may serve.
I certainly can understand that reducing memory footprint is useful, but
if we want wider testing of 4k stacks, considering they may fail in error
path in complex I/O environment, it's not likely during -rc kernels that
we'll detect problems, and if we push them down the throat of users in a
stable release, of course they will thank us very much for crashing their
NFS servers in production during peak hours.

I have nothing against changing the default setting to 4k provided that
it is easy to get back to the save setting (ie changing a config option,
or better, a cmdline parameter). I just don't agree with the idea of
forcing users to swim in the sh*t, it only brings bad reputation to
Linux.

What would really help would be to have 8k stacks with the lower page
causing a fault and print a stack trace upon first access. That way,
the safe setting would still report us useful information without
putting users into trouble.

Willy

