Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYIVQ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYIVQ3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYIVQ3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:29:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59110 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYIVQ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:29:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=O/ZUJFflB/WtTGk5PLWTJ59yHNtZCRXSb0P6XaXYCiy8c2G9JpscfI2o1sSNDPgq0
	v1csGm83Gqy9JVdwc0/tg==
Message-ID: <33307c790809220929l32427a1as3d6d6bc08ce3173b@mail.gmail.com>
Date: Mon, 22 Sep 2008 09:29:33 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: Unified tracing buffer
Cc: prasad@linux.vnet.ibm.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, hch@lst.de,
       "David Wilder" <dwilder@us.ibm.com>, zanussi@comcast.net
In-Reply-To: <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	 <20080922140740.GB5279@in.ibm.com>
	 <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
X-GMailtapped-By: 172.24.198.97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> In conjunction with the previous email on this thread
>> (http://lkml.org/lkml/2008/9/22/160), may I suggest
>> the equivalent interfaces in -mm tree (2.6.27-rc5-mm1) to be:
>>
>> relay_printk(<some struct with default filenames/pathnames>, <string>,
>> ....) ;
>> relay_dump(<some struct with default filenames/pathnames>, <binary
>> data>);
>> and
>> relay_cleanup_all(<the struct name>); - Single interface that cleans up
>> all files/directories/output data created under a logical entity.
>
> Dude, relayfs is such a bad performing mess that extending it seems like
> a bad idea. Better to write something new and delete everything relayfs
> related.

There did seem to be pretty universal agreement that we'd rather not
use relayfs.

> Also, it seems prudent to separate the ring-buffer implementation from
> the event encoding/decoding facilities.

Right - in conversation I had with Mathieu later, he suggested cleaning up
relayfs - I fear this will delay us far too long, and get bogged down.
If we can get one clean circular buffer implementation, then both
relayfs and the tracing could share that common solution,
