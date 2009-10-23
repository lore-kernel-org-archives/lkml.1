Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZJWREb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZJWREb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 13:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbZJWREb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 13:04:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51603 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbZJWREa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 13:04:30 -0400
Date: Fri, 23 Oct 2009 19:04:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Erwan Velu <erwanaliasr1@gmail.com>,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] dmi_check_system can generate Warnings when no DMI
	table is present
Message-ID: <20091023170428.GA25484@elte.hu>
References: <4AE178AF.3010804@gmail.com> <20091023110323.GC10071@elte.hu> <4AE19867.5070705@gmail.com> <1256302066.10493.74.camel@desktop> <4AE1C5C6.7000103@gmail.com> <1256310576.10493.78.camel@desktop> <20091023153027.GA18068@elte.hu> <4AE1E117.2000005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE1E117.2000005@goop.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 10/23/09 08:30, Ingo Molnar wrote:
> >> Ingo mentioned that the returning mechanism your adding was left out 
> >> intentionally to catch this error, so I don't think your original 
> >> patch could be included ..
> >>     
> > Yes. That mechanism found a real bug here.
> >
> > Calling the DMI code too early (when the strings are still empty) 
> > can cause silent failures: we wont crash but we might miss to act on 
> > DMI quirks.
> 
> Yes.  There's nothing preventing the DMI subsystem from being 
> initialized under Xen; in fact we rely on it in a dom0 kernel (which 
> does have access to the DMI tables).  I don't know what the underlying 
> bug in the original report is, but there's more to it than failing to 
> init DMI.

yeah. It's probably some init ordering problem - some version of Xen 
calling into the DMI code too early. It probably doesnt even matter in 
practice as we rarely rely on DMI details in Xen guests, right?

	Ingo
