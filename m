Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbYIWJet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbYIWJet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYIWJel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:34:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:40720 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYIWJek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:34:40 -0400
Subject: Re: Unified tracing buffer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tom Zanussi <zanussi@comcast.net>
Cc: prasad@linux.vnet.ibm.com, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
In-Reply-To: <1222147545.6875.135.camel@charm-linux>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	 <20080922140740.GB5279@in.ibm.com>
	 <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
	 <1222147545.6875.135.camel@charm-linux>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 11:31:09 +0200
Message-Id: <1222162270.16700.57.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-23 at 00:25 -0500, Tom Zanussi wrote:

> - get rid of anything having to do with padding, nobody needs it and its
> only affect has been to horribly distort and complicate a lot of the
> code
> - get rid of sub-buffers, they just cause confusion
> - get rid of mmap, nobody uses it
> - no sub-buffers and no mmap support means we can get rid of most of the
> callbacks, and a lot of API confusion along with them
> - add relay flags - they probably should have been used from the
> beginning and options made explicit instead of being shoehorned into the
> callback functions.

 - get rid of the vmap buffers as they cause tlb pressure and eat up
precious vspace on 32 bit platforms.

