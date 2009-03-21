Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZCUJ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZCUJ5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 05:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZCUJ5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 05:57:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47948 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZCUJ5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 05:57:08 -0400
Date: Sat, 21 Mar 2009 10:56:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perfcounters: fix type/event_id layout on big-endian
	systems
Message-ID: <20090321095651.GA7201@elte.hu>
References: <18884.29385.854691.357234@cargo.ozlabs.ibm.com> <20090321094246.GA5594@elte.hu> <18884.47341.106849.379374@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18884.47341.106849.379374@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > hm, this ifdef really looks ugly. How about just changing event_id 
> > to 64 bits and having a separate u32 type field? The size impact is 
> > minimal, the cleanliness win is significant :-)
> 
> We wanted to get a complete and unique identifier for the event 
> into 64 bits so that we could put it into the ring buffer for 
> PERF_RECORD_GROUP and have it take up only one 8-byte slot and yet 
> identify uniquely which counter's value follows it.  I don't know 
> that that is absolutely necessary but it sounds like a nice 
> property.
> 
> We could easily go back to a 1-bit raw field and have the type be 
> either a 64-bit raw value or an 8-bit type plus 32 or 56-bit 
> event_id.
> 
> Or we could keep the current layout but use explicit shifts and 
> masks rather than bitfields.
> 
> I don't know the current C rules concerning unions very well, but 
> I have the impression that writing to one member of a union and 
> reading another is undefined behaviour, which is another strike 
> against the current code if true...
>
> Anyway, the point is that the current code doesn't compile on 
> powerpc and wouldn't work properly even if it did, so we need to 
> do something.

yeah - i pulled your fix, thanks Paul.

Maybe the best option is to get rid of the bitfields and use masks 
...

	Ingo
