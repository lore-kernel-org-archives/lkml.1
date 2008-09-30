Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbYI3RXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbYI3RXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 13:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYI3RXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 13:23:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:48956 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYI3RXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 13:23:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=yFsPJJDYGHrdU1r86WK8fPmukkil7bZYMyKlPp31qZmIX1qaozSM9i5/2+nsSztgh
	ATa6nZyDZXDuvZ356hzdw==
Message-ID: <33307c790809301023v1b0755fbsab1bbfa9bfaad58@mail.gmail.com>
Date: Tue, 30 Sep 2008 10:23:21 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] LTTng relay buffer allocation, read, write
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       prasad@linux.vnet.ibm.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, hch@lst.de,
       "David Wilder" <dwilder@us.ibm.com>,
       "Tom Zanussi" <zanussi@comcast.net>
In-Reply-To: <33307c790809301022q2821ecc7iabf41eb513707e0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080927134012.GA11930@Krystal>
	 <1222535419.16700.300.camel@lappy.programming.kicks-ass.net>
	 <20080929155004.GA11029@Krystal>
	 <1222709445.23876.70.camel@twins.programming.kicks-ass.net>
	 <20080929203124.GA23070@Krystal>
	 <alpine.DEB.1.10.0809291643570.8145@gandalf.stny.rr.com>
	 <33307c790809301022q2821ecc7iabf41eb513707e0c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 10:22 AM, Martin Bligh <mbligh@google.com> wrote:
>> A 4 byte dataless payload is useless anyway.
>
> Not at all convinced that's true - we used it for lots of things.
> Start and end of irq event is one frequent example.
>
> Also, in a compact mode, we can record start and end of
> syscalls like this (without parameters).

Ah, sorry, maybe I misread this. No data with no event ids, etc
is fairly useless. 4 bytes data including space to record event ids is OK.
