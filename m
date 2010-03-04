Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0CDI6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:58:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:57279 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab0CDI6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:58:08 -0500
Subject: Re: [RFC][PATCH 08/11] perf, x86: Implement simple LBR support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com
In-Reply-To: <bd4cb8901003031352x60bd48dfr6431260b3d824a72@mail.gmail.com>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.451251096@chello.nl>
	 <bd4cb8901003031352x60bd48dfr6431260b3d824a72@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 09:58:06 +0100
Message-ID: <1267693086.25158.147.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 22:52 +0100, Stephane Eranian wrote:
> On Wed, Mar 3, 2010 at 5:39 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Implement support for Intel LBR stacks that support
> > FREEZE_LBRS_ON_PMI. We do not (yet?) support the LBR config register
> > because that is SMT wide and would also put undue restraints on the
> > PEBS users.
> >
> You're saying PEBS users have priorities over pure LBR users?
> Why is that?

I say no such thing, I only say it would make scheduling the PEBS things
more interesting.

> Without coding this, how would you expose LBR configuration to userland
> given you're using the PERF_SAMPLE_BRANCH_STACK approach?

Possibly using a second config word in the attr, but given how sucky the
hardware currently is (sharing the config between SMT) I'd be inclined
to pretend it doesn't exist for the moment.

