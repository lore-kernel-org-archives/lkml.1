Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbZE0Uch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbZE0Uch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbZE0UcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:32:20 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11124 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZE0UcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:32:19 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 May 2009 16:32:19 EDT
Date: Wed, 27 May 2009 22:25:50 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
In-Reply-To: <20090526234109.GL846@one.firstfloor.org>
Message-ID: <alpine.LNX.2.00.0905272223080.2477@swampdragon.chaosbits.net>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com> <878wkjobbm.fsf@basil.nowhere.org> <20090526160017.98fc62e4.akpm@linux-foundation.org> <20090526231428.GK846@one.firstfloor.org> <20090526162821.02e11d5b.akpm@linux-foundation.org>
 <20090526234109.GL846@one.firstfloor.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Andi Kleen wrote:

> On Tue, May 26, 2009 at 04:28:21PM -0700, Andrew Morton wrote:
> > On Wed, 27 May 2009 01:14:28 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > On Tue, May 26, 2009 at 04:00:17PM -0700, Andrew Morton wrote:
> > > > dump_write() doesn't seem right, either.  If ->write() returns, say,
> > > > 100 then the dump should keep on going.  At present it treats this
> > > > return as an error.
> > > 
> > > I think that's correct actually. Short write typically means serious 
> > > issue like disk full or broken pipe, so stopping is good.
> > 
> > But we shouldn't assume that.  It could be that the ->write
> > implementation is perfectly able to absorb the remaining data.
> 
> Maybe in theory, but in practice that's unlikely isn't it?
> Disk is full or pipe is blocking etc.
> 
> > We should only error out of the write() returned zero or -EFOO.
> > The current code is simply buggy, but got lucky.
> 
> Maybe very pedantically, but I would argue that most programs 
> don't do what you're saying (retry on any short write) and
> it's actually not very nice to always write a loop for each write.
> 
My experience, from userspace, both with the codebases I currently work on 
professionally and my own hobby projects, is that people usually write a 
"write wrapper" function that deals with short writes, interrupted system 
call etc and then just call the wrapper so one does not have to open-code 
a loop everywhere one wants to call write() - one just calls the wrapper 
function that does the right thing.

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

