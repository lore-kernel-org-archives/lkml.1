Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYLGTz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYLGTz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 14:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbYLGTzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 14:55:50 -0500
Received: from cmpxchg.org ([85.214.51.133]:53373 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbYLGTzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 14:55:49 -0500
Date: Sun, 7 Dec 2008 20:55:38 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] uml: drop const qualifier for kernel_execve()
Message-ID: <20081207195537.GA24808@cmpxchg.org>
References: <2375c9f90812021451hfd77292yf2463ca99d07b88e@mail.gmail.com> <20081203012051.GA8953@cmpxchg.org> <2375c9f90812030432m771984edkdd0c599bbae9bb3c@mail.gmail.com> <20081203134035.GA17560@cmpxchg.org> <2375c9f90812051702m217ee049i79ce2f9cc8280fb1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f90812051702m217ee049i79ce2f9cc8280fb1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 01:02:16AM +0000, Américo Wang wrote:
> On Wed, Dec 3, 2008 at 1:40 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > On Wed, Dec 03, 2008 at 12:32:02PM +0000, Américo Wang wrote:
> >> On Wed, Dec 3, 2008 at 1:20 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> >> > On Tue, Dec 02, 2008 at 10:51:09PM +0000, Américo Wang wrote:
> >> >> UML implementation of kernel_execve() should not have const qualifier,
> >> >> because it will finally call do_execve() which doesn't have.
> >> >
> >> > And you made sure that do_execve() is correctly annotated?
> >> >
> >>
> >> Yes, I checked that.
> >
> > Good.  Then please fix up do_execve() or let the warning stand out as
> > a reminder.
> 
> ??
> Confused...
> 
> do_execve() is OK, we don't need to fix it.

I don't see where it writes through @filename.  So it seems the right
fix would be to make do_execve()s parameter const (and as it seems, a
lot more adjustments down this call graph) and not remove a correct
const from a callsite.

	Hannes
