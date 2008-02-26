Return-Path: <linux-kernel-owner+w=401wt.eu-S1761507AbYBZI4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507AbYBZI4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 03:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759089AbYBZI4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 03:56:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58930 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756659AbYBZI4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 03:56:06 -0500
Date: Tue, 26 Feb 2008 09:55:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       sandmann@redhat.com, tglx@tglx.de, hpa@zytor.com,
       levon@movementarian.org
Subject: Re: [PATCH] x86: add the debugfs interface for the sysprof tool
Message-ID: <20080226085541.GE9857@elte.hu>
References: <20080219123756.6261c13c@laptopd505.fenrus.org> <20080223001130.d8922136.akpm@linux-foundation.org> <84144f020802230351o24b11282vbb1cecf518d91825@mail.gmail.com> <20080223104611.a3430285.akpm@linux-foundation.org> <47C0DB2E.5000404@cs.helsinki.fi> <1203822747.2439.1.camel@entropy> <84144f020802252227t729e8b0bif9c3c65e17304fd1@mail.gmail.com> <84144f020802252248g7aa7c8dbx9ddf389f3962f836@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020802252248g7aa7c8dbx9ddf389f3962f836@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi,
> 
> On Tue, Feb 26, 2008 at 8:27 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > >  You could try passing the --callgraph option to opcontrol.
> >
> >  Hmm, perhaps I am missing something but I don't think that does what
> >  sysprof does. At least I can't find where in the oprofile kernel code
> >  does it save the full stack trace for user-space. John?
> 
> Ok, so as pointed out by Nicholas/Andrew, oprofile does indeed do 
> exactly what sysprof does (see 
> arch/x86/oprofile/backtrace.c::backtrace_address, for example). So, 
> Soeren, any other reason we can't use the oprofile kernel module for 
> sysprof?

as i pointed it out earlier in the thread, the oprofile implementation 
seems buggy because when an event comes from NMI context 
__copy_from_user_inatomic() can fault and re-enable NMIs - causing 
possible stack recursion/corruption. Does not look like an easy fix.

	Ingo
