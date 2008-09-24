Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYIXU4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYIXU4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbYIXU4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:56:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57688 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYIXU4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:56:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=lYmrI0JlY4azsrRSWZD57HXqXLR9F+xA1IIYa/aoZFhjmf7wVOTNOiRYSClrJyVgl
	jT6CsW6+MyzIGkj1NQcFg==
Message-ID: <33307c790809241356l79acc57cxa4fb84c1e5dae1da@mail.gmail.com>
Date: Wed, 24 Sep 2008 13:56:38 -0700
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
In-Reply-To: <alpine.LFD.1.10.0809241330270.3265@nehalem.linux-foundation.org>
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
	 <33307c790809241104k2af4b900w781aba1a1393004b@mail.gmail.com>
	 <alpine.LFD.1.10.0809241330270.3265@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 24 Sep 2008, Martin Bligh wrote:
>>
>> If we use 32 bits instead of 27, then the timestamp events are only
>> about once per second, which is probably fine for overhead ... ?
>
> You'd have them ONCE IN A BLUE MOON.
>
> If there is nothing going on, you don't need the timestamps at all.

Yeah, you're right - we can just mark it dirty, and 'pre-log' the timestamp
events when someone calls a reserve and we haven't logged anything
for more time than we can store. Did not think of that. Was only 5 bits
for us, not an extra 37, but still, is much better.

Is a 5-bit event id generic enough though?
