Return-Path: <linux-kernel-owner+w=401wt.eu-S935206AbZDCRfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935206AbZDCRfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933847AbZDCRfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:35:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33845 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356AbZDCRfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:35:00 -0400
Date: Fri, 3 Apr 2009 19:32:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: 2.6.29 git, resume from ram broken on thinkpad
Message-ID: <20090403173256.GA6295@elte.hu>
References: <200904011155.20751.a.miskiewicz@gmail.com> <200904030222.57469.a.miskiewicz@gmail.com> <20090403003523.GK18394@sequoia.sous-sol.org> <200904030847.19674.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904030847.19674.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arkadiusz Miskiewicz <a.miskiewicz@gmail.com> wrote:

> On Friday 03 of April 2009, Chris Wright wrote:
> > * Arkadiusz Miskiewicz (a.miskiewicz@gmail.com) wrote:
> > > What about 9ea09af3bd3090e8349ca2899ca2011bd94cda85 ?
> > >
> > > stop_machine: introduce stop_machine_create/destroy.
> >
> > That is later fixed in a0e280e0f33f6c859a235fb69a875ed8f3420388.
> >
> > Can you please verify if 2.6.29 works for you? 
> 
> I think that the guilty part is 
> CONFIG_CC_STACKPROTECTOR_ALL=y
> CONFIG_CC_STACKPROTECTOR=y

aha!!

> Disabling stackprotector makes problem go away (and my build of 
> final 2.6.29 had it disabled while later builds got it enabled at 
> some moment).

Thanks a ton for that info. Could you try:

   http://people.redhat.com/mingo/tip.git/README

with stack-protector re-enabled please? This fix:

  1f23b77: x86: disable stack-protector for __restore_processor_state()

might do the trick!

	Ingo
