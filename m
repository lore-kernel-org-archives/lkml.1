Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbZF0RCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbZF0RCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZF0RCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:02:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39776 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbZF0RCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:02:04 -0400
Date: Sat, 27 Jun 2009 19:01:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 8/9] x86/apic: match destination id with destination
	mode
Message-ID: <20090627170158.GA21595@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E7@orsmsx508.amr.corp.intel.com> <20090626071725.GE14078@elte.hu> <m1hby293fh.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hby293fh.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > The question here is whether this should layer on top of 
> > Jeremy's IO-APIC driverization patches. I think it should.
> 
> The patch is a bad hack that is totally misdocumented.  A bit like 
> the Xen apic changes in that respect.
> 
> I haven't seen Jeremy's IO-APIC driverization patches.
> 
> I am stumped why we need any driverization in this area.  x86_64 
> and has had for years a mechanism that is perfectly fine for 
> abstracting this. i386 also has had something similar and last I 
> looked we just about had that code merged.

We have the local apic abstracted out into struct apic on both 
32-bit and 64-bit, but not the IO-APIC methods.

> Xen doesn't have ioapics so it doesn't need us faking writes to 
> ioapics.  Xen either needs to parse the ioapic tables itself or 
> Xen needs a proper interface to be given the table information.
> 
> I this patch can be replaced by a 2 line change to the apic mode 
> logic to force us into physflat mode on moorestown.

Yes, probably. I havent looked deeply into all the merits yet, there 
were so many other structural problems with these patches.

	Ingo
