Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595Ab0AHBEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0AHBEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 20:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198Ab0AHBEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 20:04:38 -0500
Received: from mx2.netapp.com ([216.240.18.37]:49739 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab0AHBEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 20:04:38 -0500
X-IronPort-AV: E=Sophos;i="4.49,238,1262592000"; 
   d="scan'208";a="298899070"
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
References: <1262896174.2659.3.camel@localhost>
	 <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>
	 <20100107235149.GD16076@basil.fritz.box>
	 <1262909682.2659.45.camel@localhost>
	 <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Thu, 07 Jan 2010 20:03:21 -0500
Message-ID: <1262912601.2659.89.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
X-OriginalArrivalTime: 08 Jan 2010 01:04:19.0368 (UTC) FILETIME=[81AF1280:01CA8FFE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 16:34 -0800, Linus Torvalds wrote: 
> 
> On Thu, 7 Jan 2010, Trond Myklebust wrote:
> > 
> > Yes. I want to pursue Peter Zijlstra's patches, which split up the mmap
> > function into a set of parts which require the mmap_sem, and other parts
> > which don't, and that adds a filesystem callback that allows for
> > revalidation to occur outside the mmap_sem.
> 
> I'm sorry, but that just sounds STUPID.
> 
> Why?
> 
> Because it means that you can trivially take page faults before the thing 
> is validated (think threads).

Which would mean that another process/thread already has part of the
file mmapped on the same client. I'm not arguing that have to revalidate
in _that_ case.

> If that is ok, then why do the revalidate at all? Just do the open/close 
> consistency and validate at open time, not mmap time.

That violates the expected semantics of the 'noac' mount option.

Trond
