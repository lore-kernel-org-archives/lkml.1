Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110Ab0AHAfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab0AHAfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064Ab0AHAfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:35:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876Ab0AHAfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:35:05 -0500
Date: Thu, 7 Jan 2010 16:34:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
In-Reply-To: <1262909682.2659.45.camel@localhost>
Message-ID: <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
References: <1262896174.2659.3.camel@localhost>  <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>  <20100107235149.GD16076@basil.fritz.box> <1262909682.2659.45.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Trond Myklebust wrote:
> 
> Yes. I want to pursue Peter Zijlstra's patches, which split up the mmap
> function into a set of parts which require the mmap_sem, and other parts
> which don't, and that adds a filesystem callback that allows for
> revalidation to occur outside the mmap_sem.

I'm sorry, but that just sounds STUPID.

Why?

Because it means that you can trivially take page faults before the thing 
is validated (think threads).

If that is ok, then why do the revalidate at all? Just do the open/close 
consistency and validate at open time, not mmap time.

		Linus
