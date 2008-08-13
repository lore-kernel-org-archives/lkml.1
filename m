Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbYHMUPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbYHMUPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYHMUPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:15:35 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:40329 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbYHMUPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:15:34 -0400
Subject: Re: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock,
	0) in kernel_kexec()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, torvalds@linux-foundation.org,
       ying.huang@intel.com, pavel@ucw.cz, nigel@nigel.suspend2.net,
       rjw@sisk.pl, vgoyal@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20080813124406.21091eae.akpm@linux-foundation.org>
References: <1218618760.24951.137.camel@caritas-dev.intel.com>
	 <alpine.LFD.1.10.0808130956360.3462@nehalem.linux-foundation.org>
	 <m1r68shjhb.fsf@frodo.ebiederm.org>
	 <20080813124406.21091eae.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 16:15:04 -0400
Message-Id: <1218658504.9042.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 31F7882AC4B57658FB10F4EB1D6418552B98C371
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 163 total 9497782 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-13 at 12:44 -0700, Andrew Morton wrote:

> - Is xchg() guaranteed to be atomic?  That's what atomic_xchg() is for.

Yes, xchg() is guaranteed to be atomic. atomic_xchg() applies only to
the atomic_t type, and is almost always #defined to xchg().

> - xchg() isn't guaranteed to exist on all architectures.  atomic_xchg() is.

You appear to be confusing xchg() with cmpxchg(). AFAIK, xchg() exists
on all architectures, and is used in several instances of generic code.
It is particularly extensively used in the networking layer.

Trond

