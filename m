Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZISLaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZISLaM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 07:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbZISLaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 07:30:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:44118 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbZISLaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 07:30:10 -0400
Date: Sat, 19 Sep 2009 13:30:13 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Jim Meyering <jim@meyering.net>, Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: efficient access to "rotational";  new fcntl?
Message-ID: <20090919133013.5a27290c@infradead.org>
In-Reply-To: <4AB4BC6A.3020104@redhat.com>
References: <87vdjgqcbd.fsf@meyering.net>
	<20090918221658.GB28781@mit.edu>
	<87pr9npdlc.fsf@meyering.net>
	<20090919103149.54258081@infradead.org>
	<87k4zvpak6.fsf@meyering.net>
	<20090919111912.34a35f95@infradead.org>
	<4AB4BC6A.3020104@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Sep 2009 14:11:38 +0300
Avi Kivity <avi@redhat.com> wrote:

> On 09/19/2009 12:19 PM, Arjan van de Ven wrote:
> >> However, sort *would* benefit, and some UCLA students implemented
> >> that for a term project.  Unfortunately, the project is stalled
> >> because the implementation was not efficient enough, and no one
> >> has found the time to improve it since.
> >>      
> > parallel sort... call me skeptical. My gut feeling is that you'll
> > get killed by communication overhead.
> > (sort seems to be more communication than raw cpu use)
> >
> >    
> 
> Why?  a sort that fits in memory is purely cpu and memory access.

memory access == communication due to cache line bounces....

> 
> Instead of O(N log N) you'd get K * O(N/K log N/K) followed by an
> O(N) merge.  For large N and small K, you get a speedup of roughly K
> (since the O(N) merge is dominated by the preceding sort.

doing big-O arithmatic and then add constant divisions/multipliers is
rather.. dangerous ;)

You actually get K * C1 * O(N/K log N/K) + C2 * O(N)
where C1/C2 is the actual cost of the extra intra-cpu communication.
(and for most sorting, I suspect the communication costs dominate over
CPU cost)

I'd be happy to be proven wrong... 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
