Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbYI3UuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYI3UuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYI3Ut6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:49:58 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21892 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbYI3Ut6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:49:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=LVz6Rdlq5Ljip/bqpuoYnjG/ai8/YRziJIHFYZLeWVzyDNqsu/LuKDdfutYgAdADX
	db+vKF4Bb9SVZqEsaySow==
Message-ID: <33307c790809301349g6f702ffq356c37e24cdfaa63@mail.gmail.com>
Date: Tue, 30 Sep 2008 13:49:48 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       prasad@linux.vnet.ibm.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, hch@lst.de,
       "David Wilder" <dwilder@us.ibm.com>,
       "Tom Zanussi" <zanussi@comcast.net>
In-Reply-To: <20080930195409.GA24169@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080929155004.GA11029@Krystal> <20080929203124.GA23070@Krystal>
	 <alpine.DEB.1.10.0809291643570.8145@gandalf.stny.rr.com>
	 <33307c790809301022q2821ecc7iabf41eb513707e0c@mail.gmail.com>
	 <33307c790809301023v1b0755fbsab1bbfa9bfaad58@mail.gmail.com>
	 <20080930181436.GA19690@Krystal>
	 <alpine.DEB.1.10.0809301421330.6224@gandalf.stny.rr.com>
	 <20080930183531.GA20670@Krystal>
	 <33307c790809301244x40218be6of61b53104b8d7da3@mail.gmail.com>
	 <20080930195409.GA24169@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am not saying anything about the actual number of events with 0 bytes
> payload I actually have in my own instrumentation, if this is what you
> mean. I am just saying that it leaves this room available for such
> events.

It would, yes. Are they useful?

> Even if there is a 32 bits payload associated with those events, the
> fact that we can encode the event ID in the 32 bits header will bring
> those events from 96 bits (due to 32 bits alignment) down to 64 bits.

That's true. So do we have a bunch of stuff that we really really need
that'd fit into 32 bits, but not 28 bits?

>> This is all over 1 bit of information, right? Since you need at least 1 for
>> the timestamp stuff.
>
> 4 bits of information could be added to the 32-bits header if we allow
> tracers to register their first 15 event IDs in those 4 bits.
>
> But well... let's keep that for v2. ;)

Sounds like a plan ;-) All this stuff is internal representations anyway.
