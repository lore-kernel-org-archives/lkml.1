Return-Path: <linux-kernel-owner+w=401wt.eu-S1764355AbZEAD2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764355AbZEAD2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 23:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbZEAD2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 23:28:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36042 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZEAD2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 23:28:03 -0400
Date: Thu, 30 Apr 2009 23:28:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter
 atomic
In-Reply-To: <20090430200607.9fc386ae.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0904302325200.20374@gandalf.stny.rr.com>
References: <20090501022210.851418183@goodmis.org> <20090501022403.826182932@goodmis.org> <20090430200607.9fc386ae.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Thu, 30 Apr 2009, Andrew Morton wrote:

> On Thu, 30 Apr 2009 22:22:13 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > @@ -405,7 +405,7 @@ struct ring_buffer_per_cpu {
> >  	unsigned long			nmi_dropped;
> >  	unsigned long			commit_overrun;
> >  	unsigned long			overrun;
> > -	unsigned long			entries;
> > +	atomic_t			entries;
> 
> This switches `entries' from unsigned-64-bit to signed-32-bit.

Good point. Although I doubt we will have more that 2billion entries in 
one cpu buffer. But it can happen. I'll change that to 64 bit atomic.


> 
> The signedness thing is just an unfortunate thing with atomic_t and probably
> doesn't matter.
> 
> The change in size might or might not be a bug - that's for the person
> who didn't document the data structure to work out ;)
> 
> 
> 
> 
> /*
>  * head_page == tail_page && head == tail then buffer is empty.
>  */
> struct ring_buffer_per_cpu {
> 
> the comment refers to vaporfields?
> 

Ug, the head_page and tail_page are in this struct. But the "head" and 
"tail" are with in the "head_page" and "tail_page" respectively.

-- Steve



