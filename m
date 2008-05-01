Return-Path: <linux-kernel-owner+w=401wt.eu-S1764858AbYEAW2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764858AbYEAW2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483AbYEAW2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:28:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbYEAW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:28:00 -0400
Date: Thu, 1 May 2008 15:27:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Adrian Bunk <bunk@kernel.org>, venkatesh.pallipadi@intel.com,
       davem@davemloft.net, trini@kernel.crashing.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
In-Reply-To: <20080501152051.4eb4bad3.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com> <20080501215633.GU29330@cs181133002.pp.htv.fi>
 <20080501152051.4eb4bad3.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Andrew Morton wrote:
> > 
> > I see only the following choices:
> > - remove __weak and replace all current usages
> > - move all __weak functions into own files, and ensure that also happens
> >   for future usages
> > - #error for gcc 4.1.{0,1}
> 
> Can we detect the {0,1}?  __GNUC_EVEN_MORE_MINOR__?

It's __GNUC_PATCHLEVEL__, I believe.

So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1} 
(bad, and rather uncommon).

And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare to 
begin with, I think it's better to just not support it.

			Linus
