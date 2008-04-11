Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbYDKRz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbYDKRz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 13:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760379AbYDKRzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 13:55:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60996 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759125AbYDKRzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 13:55:21 -0400
Subject: Re: VM - a plenty of inactive memory
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Grimm <agrimm61@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <cf40c6a90804090657j7e76a84foeaf3c1c02d2a7b73@mail.gmail.com>
References: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com>
	 <874pabrx6b.fsf@saeurebad.de>
	 <cf40c6a90804090657j7e76a84foeaf3c1c02d2a7b73@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 19:55:15 +0200
Message-Id: <1207936515.7524.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 15:57 +0200, Andreas Grimm wrote:
> Hi Johannes,
> 
> i know this. But why the kernel locks that memory for a so long time
> (2 days now)?

It should not be locked (being on the inactive list does not imply that
in any way). Being on the inactive list just means its first in line to
be looked at when memory needs to be reclaimed.

>  Is there a way to enforce the reclaiming? 

Why would you want to do that for? Would you not rather have a copy of
some page in memory than having to go back to disk to fetch it? Free
memory is a waste, better have something in it that might potentially be
used again.

> And how can i
> find out, which process owns that memory. The problem is, that i can't
> accept, that the free memory fell down to 50MB, when i have 24GB in
> the nirvana. 

See above, free memory is a waste. Really, you don't want 24GB of free
memory.

> The system was recently very close to the awkward
> situation to swap to disk, and i bet it will do so in the next few
> days, because it happened before. Unintelligible, if one got that much
> ram.

If it really would have hit swap then it just means you have a _lot_ of
anonymous memory and little page cache pages on that inactive list.
Check Cached and AnonPages.

