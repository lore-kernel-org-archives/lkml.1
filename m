Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZKHQrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZKHQrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbZKHQrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:47:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35092 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbZKHQrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:47:14 -0500
Date: Sun, 8 Nov 2009 17:47:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 02/11] Add "handle page fault" PV helper.
Message-ID: <20091108164706.GB3286@elte.hu>
References: <20091102092214.GB8933@elte.hu>
 <20091102160410.GF27911@redhat.com>
 <20091102161248.GB15423@elte.hu>
 <20091102162234.GH27911@redhat.com>
 <20091102162941.GC14544@elte.hu>
 <20091102174208.GJ27911@redhat.com>
 <20091108113654.GO11372@elte.hu>
 <4AF6BCE5.3030701@redhat.com>
 <20091108125135.GA13099@elte.hu>
 <4AF6F57C.6060706@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF6F57C.6060706@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/08/2009 04:51 AM, Ingo Molnar wrote:
> > 
> > * Avi Kivity <avi@redhat.com> wrote:
> > 
> >> On 11/08/2009 01:36 PM, Ingo Molnar wrote:
> >>>> Three existing callbacks are: kmemcheck, mmiotrace, notifier. Two
> >>>> of them kmemcheck, mmiotrace are enabled only for debugging, should
> >>>> not be performance concern. And notifier call sites (two of them)
> >>>> are deliberately, as explained by comment, not at the function entry,
> >>>> so can't be unified with others. (And kmemcheck also has two different
> >>>> call site BTW)
> >>>
> >>> We want mmiotrace to be generic distro capable so the overhead when 
> >>> the hook is not used is of concern.
> >>
> >> Maybe we should generalize paravirt-ops patching in case if (x) f() is 
> >> deemed too expensive.
> > 
> > Yes, that's a nice idea. We have quite a number of 'conditional 
> > callbacks' in various critical paths that could be made lighter via such 
> > a technique.
> > 
> > It would also free new callbacks from the 'it increases overhead 
> > even if unused' criticism and made it easier to add them.
> 
> There are a number of other things were we permanently bind to a 
> single instance of something, too.  Optimizing those away would be 
> nice. Consider memcpy(), where we may want to have different 
> implementations for different processors.

yeah.

	Ingo
