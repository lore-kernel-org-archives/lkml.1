Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYEKQTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYEKQTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 12:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYEKQTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 12:19:41 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:56055 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754617AbYEKQTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 12:19:40 -0400
Message-Id: <1210522779.16917.1252546109@webmail.messagingengine.com>
X-Sasl-Enc: fhMmj2ktjPH07ox0EPl6jIn3/5UQfy5jZtJIHDSq2/gw 1210522779
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Matthew Wilcox" <matthew@wil.cx>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Paul Jackson" <pj@sgi.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "linux-arch" <linux-arch@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080511135039.GA3286@mailshack.com>
   <20080511152440.GX19219@parisc-linux.org>
Subject: Re: [PATCH] Make for_each_cpu_mask a bit smaller
In-Reply-To: <20080511152440.GX19219@parisc-linux.org>
Date: Sun, 11 May 2008 18:19:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 11 May 2008 09:24:40 -0600, "Matthew Wilcox" <matthew@wil.cx>
said:
> On Sun, May 11, 2008 at 03:50:39PM +0200, Alexander van Heukelum wrote:
> >  #if NR_CPUS > 1
> > -#define for_each_cpu_mask(cpu, mask)		\
> > -	for ((cpu) = first_cpu(mask);		\
> > -		(cpu) < NR_CPUS;		\
> > -		(cpu) = next_cpu((cpu), (mask)))
> > +#define for_each_cpu_mask(cpu, mask)				\
> > +	for ((cpu) = 0;						\
> > +		(cpu) = find_next_cpu_mask((cpu), &(mask)),	\
> > +		(cpu) < NR_CPUS; (cpu)++)
> 
> For anyone else having similar cognitive dissonance while reading this
> thinking "But won't the first call to find_next_cpu_mask return a number
> > 0", the answer is "no, find_next_bit returns the next set bit that's
> >= the number passed in, which is why we need both the cpu++ and
> find_next_cpu_mask".  

That's how it works, indeed.

> > +int find_next_cpu_mask(int n, const cpumask_t *srcp)
> > +{
> > +	return find_next_bit(srcp->bits, NR_CPUS, n);
> > +}
> > +EXPORT_SYMBOL(find_next_cpu_mask);
> 
> Maybe a better name for this function would help.  I can't think of a
> good one right now though.

I can't think of a better name, and there is find_next_bit of which
find_next_cpu_mask is just a wrapper. I think the name is good enough.

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Access all of your messages and folders
                          wherever you are

