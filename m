Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbXKOH6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbXKOH6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXKOH6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:58:33 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:23578 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751265AbXKOH6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:58:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=S44tBAjZBmNTKWUw+LfwgWGZrS2w/6ldQFK77WgJBFOMCU2xWToxcbaOuCptPenq06K+hHvigQcz6s0hg5cebUNs9JH6x3oacFEjm7/XZ6QXMyL2OnwhM9JhvBGvOR+7zooC7zoyCajxmJaEDlVUJVDG7CYQGLvnq9HT/2dAmE8=  ;
X-YMail-OSG: LuHYxQcVM1lEB864DHAHzJ6kQCLbM4RI8icakXVVkGab37uQ
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Thu, 15 Nov 2007 05:51:53 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <200711140818.59714.nickpiggin@yahoo.com.au> <200711142228.10934.david-b@pacbell.net>
In-Reply-To: <200711142228.10934.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711150551.54230.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 17:28, David Brownell wrote:
> On Tuesday 13 November 2007, Nick Piggin wrote:
> > > All this does is prevent constant and needless checking for
> > > "do you want to preempt me now?" "now?" "now?" in "now?" the
> > > middle "now?" of "now?" i/o "now?" loops.
> >
> > Actually that's wrong.
>
> Certainly it's right for the mainstream kernel.  Dropping a
> lock (other than a raw spinlock) does that checking; when a
> loop needs to acquire then drop such a lock, that's exactly
> what's going on.

Obviously a raw spinlock is no different from a regular
spinlock upstream.


> And in the RT kernel, it's got to do the same thing ...
> because dropping that lock may mean that a higher priority
> task should immediately run and grab the lock.

No, it wakes up the highest priority waiter. If that wakeup
causes a preemption, then that's fine, but it does not have
to explicitly check preemption when dropping the lock.
