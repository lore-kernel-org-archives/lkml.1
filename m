Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbXJZEET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbXJZEET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 00:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXJZEEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 00:04:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXJZEEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 00:04:05 -0400
Date: Fri, 26 Oct 2007 00:03:58 -0400
From: Rik van Riel <riel@redhat.com>
To: 7eggert@gmx.de
Cc: Richard Purdie <rpurdie@rpsys.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux machines dieing in swap storms
Message-ID: <20071026000358.56f9dec2@bree.surriel.com>
In-Reply-To: <E1IlGJV-0007vW-A6@be1.lrz>
References: <9icP2-2hb-17@gated-at.bofh.it>
	<9ifML-6Xs-25@gated-at.bofh.it>
	<E1IlGJV-0007vW-A6@be1.lrz>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 05:56:49 +0200
Bodo Eggert <7eggert@gmx.de> wrote:

> Rik van Riel <riel@redhat.com> wrote:
> > On Thu, 25 Oct 2007 16:20:41 +0100
> > Richard Purdie <rpurdie@rpsys.net> wrote:
> 
> >> Advice on solving this welcome preferably in mainline but I'll
> >> happily hack my kernels with a workaround if need be.
> > 
> > I can't see any easy hacks or workarounds to fix the issue in the
> > current MM, except maybe activate the OOM killer if the amount of
> > page cache and buffer cache is really low and swap is full...
> > 
> > In the longer run, I'm working on:
> > 
> > http://linux-mm.org/PageReplacementDesign
> 
> What about only reclaimimn cache if the cache has grown beyond a
> watermark and only reclaimimn non-cache if it's below another
> watermark? I can imagine it will solve my
> diskcache-pushes-out-mousehandler problem, and I'm pretty sure having
> very low file cache is bad for performance, too.

There are much better ways to determine such thresholds than
requiring the sysadmin to set them by hand.  I have described
one on the page linked above.

> Another thing I can imagine is to detect thrashing conditions and to
> change scheduling in order to increase the likehood of cache hits and
> thereby progress: If an application just got a page, keep it running
> for a while (accumulating negative credits).

If the process needs another page after the page it just
got (very likely), you cannot "keep it running".

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
