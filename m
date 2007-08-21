Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXHUSlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXHUSlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761414AbXHUSlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:41:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760526AbXHUSlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:41:09 -0400
Date: Tue, 21 Aug 2007 11:40:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Daniel Walker <dwalker@mvista.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [12/58] x86_64: Add vDSO for x86-64 with
 gettimeofday/clock_gettime/getcpu
Message-Id: <20070821114026.41d5c9d7.akpm@linux-foundation.org>
In-Reply-To: <20070821184543.GK32640@bingen.suse.de>
References: <200707191154.642492000@suse.de>
	<20070719095456.B996214E03@wotan.suse.de>
	<1187713502.7732.65.camel@imap.mvista.com>
	<20070821184543.GK32640@bingen.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007 20:45:43 +0200 Andi Kleen <ak@suse.de> wrote:

> > In the -mm kernel there is some debugging that gets injected into the
> > likely/unlikely macros .. If they get called from userspace it causes a
> 
> They should likely define a __likely()/__unlikely() then that doesn't
> do this.
> 
> > hang .. We might want to add some new set of macros to specifically
> > denote that they are called from userspace, not just likely/unlikely but
> > all the macros so we don't get mixed usage ..
> 
> and add a hunk to change the vDSO code. Note that i386 is not the 
> only architecture that has such code.
> 

Yes, the simplest fix would be to remove all the troublesome likely/unlikely
calls within that debug patch.  I'll take a look at that, see if it fixes
the compile.
