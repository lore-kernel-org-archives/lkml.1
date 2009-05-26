Return-Path: <linux-kernel-owner+w=401wt.eu-S1760452AbZEZXey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760452AbZEZXey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759769AbZEZXeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:34:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57797 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759726AbZEZXeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:34:36 -0400
Date: Wed, 27 May 2009 01:41:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-ID: <20090526234109.GL846@one.firstfloor.org>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com> <878wkjobbm.fsf@basil.nowhere.org> <20090526160017.98fc62e4.akpm@linux-foundation.org> <20090526231428.GK846@one.firstfloor.org> <20090526162821.02e11d5b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526162821.02e11d5b.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 04:28:21PM -0700, Andrew Morton wrote:
> On Wed, 27 May 2009 01:14:28 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > On Tue, May 26, 2009 at 04:00:17PM -0700, Andrew Morton wrote:
> > > dump_write() doesn't seem right, either.  If ->write() returns, say,
> > > 100 then the dump should keep on going.  At present it treats this
> > > return as an error.
> > 
> > I think that's correct actually. Short write typically means serious 
> > issue like disk full or broken pipe, so stopping is good.
> 
> But we shouldn't assume that.  It could be that the ->write
> implementation is perfectly able to absorb the remaining data.

Maybe in theory, but in practice that's unlikely isn't it?
Disk is full or pipe is blocking etc.

> We should only error out of the write() returned zero or -EFOO.
> The current code is simply buggy, but got lucky.

Maybe very pedantically, but I would argue that most programs 
don't do what you're saying (retry on any short write) and
it's actually not very nice to always write a loop for each write.

Also any IO device who relies on that would likely find
that it won't work with a lot of software.

So I think the current behaviour is ok, just need to get 
rid of the signals.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
