Return-Path: <linux-kernel-owner+w=401wt.eu-S932766AbYEAWoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbYEAWoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYEAWoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:44:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765652AbYEAWoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:44:01 -0400
Date: Thu, 1 May 2008 15:42:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: torvalds@linux-foundation.org, bunk@kernel.org,
       venkatesh.pallipadi@intel.com, davem@davemloft.net,
       trini@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-Id: <20080501154238.eccdb6ff.akpm@linux-foundation.org>
In-Reply-To: <20080501223515.GA11366@linux-os.sc.intel.com>
References: <20080430013108.GA18207@linux-os.sc.intel.com>
	<20080429.212833.192304794.davem@davemloft.net>
	<924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com>
	<20080501215633.GU29330@cs181133002.pp.htv.fi>
	<20080501152051.4eb4bad3.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org>
	<20080501223515.GA11366@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 15:35:15 -0700
Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> On Thu, May 01, 2008 at 03:27:26PM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Thu, 1 May 2008, Andrew Morton wrote:
> > > > 
> > > > I see only the following choices:
> > > > - remove __weak and replace all current usages
> > > > - move all __weak functions into own files, and ensure that also happens
> > > >   for future usages
> > > > - #error for gcc 4.1.{0,1}
> > > 
> > > Can we detect the {0,1}?  __GNUC_EVEN_MORE_MINOR__?
> > 
> > It's __GNUC_PATCHLEVEL__, I believe.
> > 
> > So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1} 
> > (bad, and rather uncommon).
> > 
> > And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare to 
> > begin with, I think it's better to just not support it.
> > 
> 
> Not sure whether #error on gcc 4.1.{0.1} is the right thing as I found atleast
> one distro gcc which says itself as 4.1.1, do not exhibit the problem as it
> most likely has fix backported.
> 
> Putting all weak functions in one file is something Suresh and I considered
> before sending this patch. But, looking at various users of __weak, that
> single file did not look very appropriate.
> 

Is there some vaguely maintainable workaround we can do?  If the problem
only affects completely-empty weak functions then we could put something in
them to make them non-empty?

#if __GNUC__ == ...
#define weak_function_filler for ( ; ; );
#else
#define weak_function_filler()
#endif

because __weak and attribute((weak)) are pretty easy to grep for. Dunno.

