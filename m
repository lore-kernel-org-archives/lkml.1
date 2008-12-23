Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbYLWRde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbYLWRde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 12:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYLWRdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 12:33:24 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:49493 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYLWRdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 12:33:24 -0500
Date: Tue, 23 Dec 2008 18:34:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ken Chen <kenchen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       sparclinux <sparclinux@vger.kernel.org>, mingo@elte.hu,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, paulus@samba.org,
       tglx@linutronix.de, hpa@zytor.com, linux-next@vger.kernel.org
Subject: Re: [PATCH] sparc64: use unsigned long long for u64
Message-ID: <20081223173455.GC5957@uranus.ravnborg.org>
References: <20081222070426.GD29160@elte.hu> <20081222181932.5dd9514e.sfr@canb.auug.org.au> <20081222080341.GA18897@elte.hu> <20081222144319.1bfc0061.akpm@linux-foundation.org> <20081222230035.GB4074@uranus.ravnborg.org> <20081222151338.3b6ef997.akpm@linux-foundation.org> <20081223131746.GA7456@uranus.ravnborg.org> <b040c32a0812230905q3a257163r35373b0cb50df35c@mail.gmail.com> <20081223172610.GA5957@uranus.ravnborg.org> <b040c32a0812230929u282f0f2bn9221bf2e176d82eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0812230929u282f0f2bn9221bf2e176d82eb@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 09:29:52AM -0800, Ken Chen wrote:
> On Tue, Dec 23, 2008 at 9:26 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >> wait, why does this need to be changed?
> >
> > We have:
> >        clocksource_tick.read = tick_ops->get_tick;
> >
> > And clocksource_tick is of type clocksource:
> >
> > struct clocksource {
> >        ...
> >        cycle_t (*read)(void);
> >
> > And cycle_t is:
> > /* clocksource cycle base type */
> > typedef u64 cycle_t;
> >
> > And u64 is now:
> > unsigned long long - thus we need to fix prototype
> > of get_tick to fix the warnings.
> >
> > A cast could do it - but fixing the real problem
> > is better here.
> 
> Sounds good to me.  It was just a question.  Thank you for the explanation.

Hey - it triggered me to take a deeper look at it.
And thanks for actually reading the patch - it's always good that
an extra pair of eyes look over it even it is only quick browsing.

	Sam
