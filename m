Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbZCRIsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbZCRIsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZCRIru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:47:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:39547 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbZCRIrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:47:49 -0400
Subject: Re: [RFC][PATCH 09/11] perf_counter: revamp syscall input ABI
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-Reply-To: <18880.23662.233043.833458@drongo.ozlabs.ibm.com>
References: <20090317215606.037073805@chello.nl>
	 <20090317220421.336322251@chello.nl>
	 <18880.23662.233043.833458@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 09:47:43 +0100
Message-Id: <1237366063.5069.64.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 13:29 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > The hardware/software classification in hw_event->type became a little strained
> > due to the addition of tracepoint tracing.
> > 
> > Instead split up the field and provide a type field to explicitly specify the
> > counter type, while using the event_id field to specify which event to use.
> > 
> > Raw counters still work as before, only the raw config now goes into raw_event.
> 
> Interesting idea, but why not also use it to express the distinction
> between generic and raw hardware events ids?  Why not add a
> PERF_TYPE_RAW_HARDWARE to this list:
> 
> > + * hw_event.type
> > + */
> > +enum perf_event_types {
> > +	PERF_TYPE_HARDWARE		= 0,
> > +	PERF_TYPE_SOFTWARE		= 1,
> > +	PERF_TYPE_TRACEPOINT		= 2,
> > +};
> 
> and get rid of the raw bit?  That way, hw_event.raw_event is unique
> for every different event, whereas the way you have it, you still need
> to include the raw bit to get a unique id.

Ah, I thought we should keep a pure 64 bit raw value. You never know
what hardware will do.

