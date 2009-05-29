Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbZE2IKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbZE2IKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 04:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbZE2IKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 04:10:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:39027 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbZE2IKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 04:10:42 -0400
Subject: Re: [PATCH RFC] perf_counter: Don't swap contexts containing
 locked mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1243584388.23657.156.camel@twins>
References: <18975.31580.520676.619896@drongo.ozlabs.ibm.com>
	 <1243584388.23657.156.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 29 May 2009 10:10:44 +0200
Message-Id: <1243584644.23657.164.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 10:06 +0200, Peter Zijlstra wrote:
> > @@ -919,7 +919,8 @@ static int context_equiv(struct perf_counter_context *ctx1,
> >                        struct perf_counter_context *ctx2)
> >  {
> >       return ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx
> > -             && ctx1->parent_gen == ctx2->parent_gen;
> > +             && ctx1->parent_gen == ctx2->parent_gen
> > +             && ctx1->parent_gen != ~0ull;
> >  }
> 
> There's a nasty surprise for people a few generations down the line. All
> of a sudden performance drops for a while for some unknown reason, and
> then its good again,.. how odd ;-)

OK, so I was joking, but my brain just came up with:

static void inc_generation(struct perf_counter_ctx *ctx)
{
	ctx->generation = ++ctx->generation & 0x7FFFFFFFFFFFFFFF;
}


