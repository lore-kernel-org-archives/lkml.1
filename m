Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbXHVUpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbXHVUpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760575AbXHVUow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:44:52 -0400
Received: from 1wt.eu ([62.212.114.60]:2263 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760565AbXHVUov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:44:51 -0400
Date: Wed, 22 Aug 2007 22:31:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: [stable] [2.6.20.17 review 32/58] fs: 9p/conv.c error path fix
Message-ID: <20070822203121.GC14132@1wt.eu>
References: <20070822083844.%N@1wt.eu> <20070822084023.%N@1wt.eu> <a4e6962a0708220853n7689985fj71ba19b67e17ae5d@mail.gmail.com> <20070822185941.GA6129@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822185941.GA6129@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Aug 22, 2007 at 11:59:41AM -0700, Greg KH wrote:
> On Wed, Aug 22, 2007 at 10:53:02AM -0500, Eric Van Hensbergen wrote:
> > On 8/22/07, Willy Tarreau <w@1wt.eu> wrote:
> > > When buf_check_overflow() returns != 0 we will hit kfree(ERR_PTR(err))
> > > and it will not be happy about it.
> > >
> > > Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > Signed-off-by: Willy Tarreau <w@1wt.eu>
> > Acked-by: Eric Van Hensbergen <ericvh@gmail.com>
> > 
> > This seems to be in the current code as well, I'll forward-port the patch...
> 
> Huh?  It's not already in mainline?  Then how did it ever get into the
> stable queue?
> 
> Ugh.

Maybe someone sent it to stable@ and lkml at the same time and it got lost
on the second (noisy) path ? Judging from the patch, it got merged about
one month ago :

willy@pcw:2.6$ git log v2.6.20..2.6.22.x -- fs/9p/conv.c|cat
commit b3b590287ca3c36e0a3fa28d626f126dd5226fc4
Author: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date:   Thu Jul 19 17:27:22 2007 -0700

    fs: 9p/conv.c error path fix
    
    When buf_check_overflow() returns != 0 we will hit kfree(ERR_PTR(err))
    and it will not be happy about it.
    
    Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

willy@pcw:2.6$ git describe  b3b590287ca3c36e0a3fa28d626f126dd5226fc4
v2.6.22.1-53-gb3b5902

But yes, I agree that it's very annoying when -stable contains patches
that are not in mainline. Fortunately, we have careful reviewers to
catch this when it happens !

Regards,
Willy

