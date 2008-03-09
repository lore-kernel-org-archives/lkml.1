Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbYCIMAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbYCIMAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 08:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYCIMAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 08:00:39 -0400
Received: from www.tglx.de ([62.245.132.106]:41526 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbYCIMAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 08:00:38 -0400
Date: Sun, 9 Mar 2008 13:00:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
In-Reply-To: <20080309193657.C6D8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <alpine.LFD.1.00.0803091257190.3099@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309193657.C6D8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, KOSAKI Motohiro wrote:
> Hi
> 
> in general, I like this patch and I think this is very useful.
> but I don't like #ifdef ;)

/me neither :)
 
> > +#ifdef CONFIG_QUICKLIST
> > +		"QuickLists:   %8lu kB\n"
> > +#endif
> > +		,K(i.totalram),
> >  		K(i.freeram),
> >  		K(i.bufferram),
> >  		K(cached),
> > @@ -215,6 +220,9 @@ static int meminfo_read_proc(char *page,
> >  		(unsigned long)VMALLOC_TOTAL >> 10,
> >  		vmi.used >> 10,
> >  		vmi.largest_chunk >> 10
> > +#ifdef CONFIG_QUICKLIST
> > +		,K(quicklist_total_size())
> > +#endif
> 
> Do you dislike my following patch?

I like it. I'm just not sure about the accounting of cached memory in
general, though quicklists seem to be a pretty obvious one.

Thanks,

	tglx


