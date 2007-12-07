Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbXLGNEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbXLGNEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 08:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXLGNEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 08:04:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:39032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbXLGNEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 08:04:12 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: ptrace API extensions for BTS
Date: Fri, 7 Dec 2007 14:04:06 +0100
User-Agent: KMail/1.9.6
Cc: roland@redhat.com, markus.t.metzger@gmail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
References: <029E5BE7F699594398CA44E3DDF55444010F8D7C@swsmsx413.ger.corp.intel.com> <200712071218.17914.ak@suse.de> <029E5BE7F699594398CA44E3DDF55444010F9074@swsmsx413.ger.corp.intel.com>
In-Reply-To: <029E5BE7F699594398CA44E3DDF55444010F9074@swsmsx413.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712071404.06594.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2007 13:01:28 Metzger, Markus T wrote:
> >From: Andi Kleen [mailto:ak@suse.de] 
> >Sent: Freitag, 7. Dezember 2007 12:18
> 
> >> I would like to settle the discussion and find an interface that
> >> everybody can agree to, so I can implement that interface and we can
> >> move forward with the patch.
> >
> >The most efficient interface would be zero copy with tracer 
> >user process
> >supplying memory that is pinned (get_user_pages()) subject to the
> >mlock rlimit. Then kernel telling the CPU to directly log into
> >that.
> 
> That would require users to understand all kinds of BTS formats
> and to detect the hardware they are running on in order to interpret
> the data.

That's true. I guess it could be abstracted in a library, but doing
it all in kernel is indeed nicer.

Ok in theory you could go fancy and put the library into the vDSO
which runs in ring 3. Then it would be tied to the kernel again.

> So far, there are two different formats. But one of them is wasting
> an entire word of memory per record. I could imagine that this would
> change some day.
> 
> Other architectures would likely use an entirely different format.
> Users who want to support several architectures would benefit from
> a common format for this from-to branch information.

I guess some other users would prefer higher performance, but yes
there are probably both types. I don't know what is more important.

> Is there some other metric that would allow me to order BTS 
> chunks for different threads?

With Out-of-order CPUs exact global metrics are pretty difficult.
At which point of the instruction execution would you measure? 

Anyways if RDTSC doesn't work the only global alternatives are much slower
(like southbridge timers) or very inaccurate (jiffies) 

I would just drop it since it'll likely always be somewhat misleading.

-Andi
