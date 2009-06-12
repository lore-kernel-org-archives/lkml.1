Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbZFLIcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbZFLIcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZFLIcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:32:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:2814 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbZFLIcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:32:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,208,1243839600"; 
   d="scan'208";a="421122259"
Date: Fri, 12 Jun 2009 16:15:26 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -tip] perf_counter/x86: Correct some event and umask
	values for Intel processors
Message-ID: <20090612081526.GB2286@ywang-moblin2.bj.intel.com>
References: <20090609131553.GA12489@ywang-moblin2.bj.intel.com> <20090609141621.GA32703@elte.hu> <20090610053623.GC30923@ywang-moblin2.bj.intel.com> <20090610104242.GB27724@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610104242.GB27724@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 12:42:42PM +0200, Ingo Molnar wrote:
> 
> * Yong Wang <yong.y.wang@linux.intel.com> wrote:
> 
> > On Tue, Jun 09, 2009 at 04:16:21PM +0200, Ingo Molnar wrote:
> > > 
> > > * Yong Wang <yong.y.wang@linux.intel.com> wrote:
> > > 
> > > > Correct some event and UMASK values according to Intel SDM.
> > > 
> > > Very nice, thanks!
> > > 
> > > were you able to test the Atom ones by any chance?
> > > 
> > 
> > You bet I was as I'm working on Moblin ;-) [...]
> 
> Heh :-)
> 
> > [...] However, some work while some do not. I'll take a look at 
> > the problematic ones. With the previous event and umask values, 
> > the pmc does not count at all for some events, like l1d-write-ops.
> 
> Interesting. I had a good look at the Atom details in the docs but 
> couldnt find anything suspicious. There's various umask level 
> extensions (sometimes cflags level ones) like whether to measure the 
> core or the thread, but the defaults (zero) seem to have OK 
> semantics for most of the events.
> 
> Btw., when mapping out event tables there's one little trick i used 
> to 'scan' an event, using 'perf stat' and raw event numbers:
> 
>   for ((i=0;i<256;i++)); do                                    \
>     perf stat -e $(printf "r%02x%02x\n" $i 0xc0) true 2>&1 |   \
>       grep -w raw | grep -vw 0;                                \
>   done
> 
> This scans all 256 umask values for the main event code of 0xc0, and 
> displays the umask values where the counter show some activity.
> 
> ( if it's some rare event then you might want to run something else 
>   that excercises that event, not /bin/true. )
> 

Just took a look at the problematics ones and found that the fixed
function PMCs do not work on current Atom processors. I tested on 3 Atom
netbooks and the results are the same. Just sent a quirk patch for that.

-Yong
