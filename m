Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbXHLIfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbXHLIfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 04:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbXHLIfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 04:35:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54596 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbXHLIfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 04:35:36 -0400
Date: Sun, 12 Aug 2007 01:35:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>
Subject: Re: Are we properly prepared to handle 3 Socket setups?
Message-Id: <20070812013519.a5d5d59b.akpm@linux-foundation.org>
In-Reply-To: <46BE7BB6.2010607@gmail.com>
References: <9a8748490708111808o11d354fr9efa719bc38046c5@mail.gmail.com>
	<46BE621E.9090509@gmail.com>
	<9a8748490708111852y569a3e18i1c3d192e60eceafe@mail.gmail.com>
	<46BE7BB6.2010607@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 05:17:10 +0200 Rene Herman <rene.herman@gmail.com> wrote:

> On 08/12/2007 03:52 AM, Jesper Juhl wrote:
> 
> > On 12/08/07, Rene Herman <rene.herman@gmail.com> wrote:
> >> On 08/12/2007 03:08 AM, Jesper Juhl wrote:
> >>
> >>> This may be a little off topic, but I think it's interresting enough
> >>> to warrent a single mail.
> >>>
> >>> I just saw a news article (http://www.theinquirer.net/?article=41610)
> >>> about a 3 Socket Opteron motherboard and couldn't help but wonder if
> >>> we are prepared to deal with such a beast, so I thought I'd inform
> >>> everyone :-)
> >>>
> >>> I'm guessing equipping such a board with 3 single core CPU's could
> >>> show up some interresting corner cases in schedular code and
> >>> elsewhere, I'll bet we have some assumptions somewhere about
> >>> nr_of_cpus being an even number...
> >> I would hope the N=1 case will have flushed out enough of those... :-|
> >>
> > Hehe, true, but I was thinking more of nr_of_cpus is an odd number > 1. :-)
> > Just thinking of having to divide things by 3 makes me worry ;-)  ...
> 
> It's not a hugely strange worry no. Grepping around (for num_online_cpus for 
> example) didn't throw up any glaring bugs I believe.
> 
> A possible problem in mm/vmstat.c:calculate_threshold() where 3 CPUs would 
> be treated as 2 through an fls(). No idea about that code and if that would 
> be a problem.

No, that'll be OK.

> The line just below where it does that _does_ seem to have a problem:
> 
>          /*
>           * Maximum threshold is 125
>           */
>          threshold = min(125, threshold);
> 
> as either the comment or the code is wrong and it seems it's the code. Added 
> Andrew Morton to the CC for that.

Yes, that's inconsistent.  And looking at Christoph's df9ecaba it's unclear
whether the comment is wrong or the code is wrong.  The code is wrong, I
expect.

