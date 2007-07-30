Return-Path: <linux-kernel-owner+w=401wt.eu-S964989AbXGaAAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbXGaAAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933435AbXGaAAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:00:05 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:47286 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691AbXGaAAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:00:01 -0400
Date: Mon, 30 Jul 2007 16:59:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] Use ERESTARTNOHAND if poll() is interrupted by a signal
Message-ID: <20070730235935.GC3673@sequoia.sous-sol.org>
References: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com> <20070730163538.67b256da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730163538.67b256da.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Sun, 29 Jul 2007 19:05:05 +0200 Manfred Spraul <manfred@colorfullife.com> wrote:
> > poll() returns -EINTR if a signal is pending.
> > EINTR is a bad choice: it means that poll returns to user space if the
> > task is stopped by SIGSTOP/SIGCONT or by the freezer.
> > select() and ppoll() both use ERESTARTNOHAND, this avoids a return to
> > user space for signals that are handled by the kernel.
> > 
> > The patch switches poll() to ERESTARTNOHAND.
> > Tested with FC6. Patch against 2.6.23-rc1-mm1.
> 
> hm.  Is this a fix against
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/broken-out/do_poll-return-eintr-when-signalled.patch
> only, or does mainline also need fixing?

Mainline has same issue (although fix is certainly a bit different w/out
Oleg's patch).
