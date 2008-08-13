Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYHMScm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYHMScm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYHMScd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:32:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYHMScd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:32:33 -0400
Date: Wed, 13 Aug 2008 14:31:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Huang Ying <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock,
	0) in kernel_kexec()
Message-ID: <20080813183156.GA20974@redhat.com>
References: <1218618760.24951.137.camel@caritas-dev.intel.com> <alpine.LFD.1.10.0808130956360.3462@nehalem.linux-foundation.org> <m1r68shjhb.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r68shjhb.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 11:12:48AM -0700, Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Wed, 13 Aug 2008, Huang Ying wrote:
> >>
> >> -	xchg(&kexec_lock, 0);
> >> +	locked = xchg(&kexec_lock, 0);
> >> +	BUG_ON(!locked);
> >
> > Why do you want to do this at all? 
> >
> > And why do you implement your locks with xchg() in the first place? That's 
> > total and utter crap.
> >
> > Hint: we have _real_ locking primitives in the kernel.
> 
> This part certainly.
> 
> The way the code should work, and the way it has in the past is:
> image = xchg(&kexec_image, NULL)
> if (!image)
>    return -EINVAL;
> 
> Very simple and very obvious and very easy to get right, and it has
> been that way for years.
> 

Hi Eric,

Are there any issues with usage of test_and_set_bit() or usage of spinlock
primitives?

Thanks
Vivek
