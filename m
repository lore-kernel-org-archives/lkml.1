Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbYIXSEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbYIXSEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYIXSEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:04:13 -0400
Received: from smtp-out.google.com ([216.239.33.17]:29038 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbYIXSEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:04:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=dwPlm/axu3iEvPwVMNS1L8ndCYV0nvnFpVQkkqVwyvGwNCw3w1C4EVmQRbgoW4Av3
	honUc/TSRY6ZAn16Ow2kA==
Message-ID: <33307c790809241104k2af4b900w781aba1a1393004b@mail.gmail.com>
Date: Wed, 24 Sep 2008 11:04:04 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "David Wilder" <dwilder@us.ibm.com>, hch@lst.de,
       "Tom Zanussi" <zanussi@comcast.net>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924051056.650388887@goodmis.org>
	 <20080924051400.195780424@goodmis.org>
	 <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>
	 <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
	 <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
	 <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com>
	 <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>
	 <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com>
X-GMailtapped-By: 172.28.16.76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If we just record the TSC unshifted, in 27 bits, at 4GHz, that gives us
> about 1/30 of a second? So we either shift, use > 27 bits, or record
> at least 30 events a second, none of which I like much ...

If we use 32 bits instead of 27, then the timestamp events are only
about once per second, which is probably fine for overhead ... ?

I think we're OK losing 5 bits of precision, that's only 32 cycles,
given all the CPU reordering stuff we've talked about here,
not-quite-synced TSCs, etc. I suspect you thought we were
shifting by much more than this, in reality it was 5-10 bits,
with timestamp events inbetween, though we put wall time in
them, which I think was a mistake.

(note: I'm not suggesting we have to use this compact a format,
at least by default)
