Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbYHVTzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbYHVTzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbYHVTzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:55:32 -0400
Received: from peff.net ([208.65.91.99]:4411 "EHLO peff.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602AbYHVTzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:55:31 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2008 15:55:30 EDT
Date: Fri, 22 Aug 2008 15:48:46 -0400
From: Jeff King <peff@peff.net>
To: =?utf-8?B?QmrDtnJu?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Petr Baudis <pasky@suse.cz>,
       Alan.Brunelle@hp.com, linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Message-ID: <20080822194846.GA31356@coredump.intra.peff.net>
References: <48A36838.3050309@hp.com> <20080819124602.9e8e69f7.akpm@linux-foundation.org> <48AEDD3D.4060507@hp.com> <20080822092549.ddcb7e79.akpm@linux-foundation.org> <20080822171651.GP10544@machine.or.cz> <20080822105136.a8432875.akpm@linux-foundation.org> <20080822193730.GA1598@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080822193730.GA1598@atjola.homenet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 09:37:30PM +0200, Björn Steinbrink wrote:

> Yep, and that's totally correct as far as bisect is concerned. The
> parents of that merge commit are:
> 88fa08f67bee1a0c765237bdac106a32872f57d2
> b1b135c8d619cb2c7045d6ee4e48375882518bb5
> 
> And Alan marked both of them as good.
> 
> So, unless Alan made a mistake during his bisection, each of the
> branches is correct, but the merge did not lead to a correct result. So
> while there were no textual conflicts, there were still incompatible
> changes regarding the code semantics and compatibility was not restored
> during the merge.

One thing that I have seen proposed (but never tried myself) is that you
can linearize the changes using "rebase -i" (or cherry-picking), and
then bisect that result. That is, given a history

A-B-C-D
 \   /
  E-F

where the merge "D" introduces the bug, you could try creating:

  A-B-C-E'-F'

and bisecting that. And you should know that C is good from your
previous bisection, but that F' probably is not, since it should be
textually the same as D (unless, of course, you had textual conflicts
during the rebase that you fixed up differently).

So in essence you are testing each of E and F, but based on the other
work. So you should be able to find the one patch that causes the
conflict. And depending on the conflict, you may get more information by
doing it the other way. I.e.,:

  A-E-F-B'-C'

-Peff
