Return-Path: <linux-kernel-owner+w=401wt.eu-S1422975AbXCOWgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422975AbXCOWgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422977AbXCOWgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:36:24 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43768 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422975AbXCOWgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:36:22 -0400
Date: Thu, 15 Mar 2007 15:36:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>, Dan Aloni <da-x@monatomic.org>,
       linux-kernel@vger.kernel.org
Subject: Re: thread stacks and strict vm overcommit accounting
Message-Id: <20070315153613.3d2eaf10.akpm@linux-foundation.org>
In-Reply-To: <20070315233343.662b019c@lxorguk.ukuu.org.uk>
References: <20070313163320.GA28104@localdomain>
	<20070315110621.9a9defaf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703152021130.21129@blonde.wat.veritas.com>
	<20070315233343.662b019c@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 23:33:43 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Stack RSS should certainly be included in Committed_AS,
> > but RLIMIT_STACK merely limits how big the stack vma may grow to:
> > at any moment the stack vma is probably very much smaller,
> > and only its current size is accounted in Committed_AS.
> 
> With a typical size as a fuzz factor preaccounted in later kernels.

Where's that done?

> > > > Is this the intended behaviour?
> > > 
> > > That sounds like a bug to me.
> > 
> > I'm suspecting it's an oddity rather than a bug.
> 
> It is intended behaviour.

Each instance of

main()
{
	sleep(100);
}

appears to increase Committed_AS by around 200kb.  But we've committed to
providing it with 8MB for stack.

How come this is correct?

