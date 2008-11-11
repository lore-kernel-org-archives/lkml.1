Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbYKKWap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbYKKWap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbYKKWac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:30:32 -0500
Received: from vena.lwn.net ([206.168.112.25]:58404 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbYKKWaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:30:30 -0500
Date: Tue, 11 Nov 2008 15:30:28 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, avi@redhat.com
Subject: Re: [PATCH 3/4] add ksm kernel shared memory driver
Message-ID: <20081111153028.422b301a@bike.lwn.net>
In-Reply-To: <491A0483.3010504@redhat.com>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>
	<1226409701-14831-2-git-send-email-ieidus@redhat.com>
	<1226409701-14831-3-git-send-email-ieidus@redhat.com>
	<1226409701-14831-4-git-send-email-ieidus@redhat.com>
	<20081111150345.7fff8ff2@bike.lwn.net>
	<491A0483.3010504@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Let's see if I can get through the rest without premature sends...]

On Wed, 12 Nov 2008 00:17:39 +0200
Izik Eidus <ieidus@redhat.com> wrote:

> > Actually, it occurs to me that there's no sanity checks on any of
> > the values passed in by ioctl().  What happens if the user tells
> > KSM to scan a bogus range of memory?
> >     
> 
> Well get_user_pages() run in context of the process, therefore it
> should fail in "bogus range of memory"

But it will fail in a totally silent and mysterious way.  Doesn't it
seem better to verify the values when you can return a meaningful error
code to the caller?

The other ioctl() calls have the same issue; you can start the thread
with nonsensical values for the number of pages to scan and the sleep
time.

> 
> > Any benchmarks on the runtime cost of having KSM running?
> >     
> 
> This one is problematic, ksm can take anything from 0% to 100% cpu
> its all depend on how fast you run it.
> it have 3 parameters:
> number of pages to scan before it go to sleep
> maximum number of pages to merge while we scanning the above pages 
> (merging is expensive)
> time to sleep (when runing from userspace using /dev/ksm, we actually
> do it there (userspace)

What about things like cache effects from scanning all those pages?  My
guess is that, if you're trying to run dozens of Windows guests, cache
usage is not at the top of your list of concerns, but I could be
wrong.  Usually am...

Thanks,

jon
