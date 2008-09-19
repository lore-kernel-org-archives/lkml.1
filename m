Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbYISV6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbYISV6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYISV6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:58:08 -0400
Received: from smtp-out.google.com ([216.239.33.17]:26661 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYISV6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:58:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=QQ3+fvgCOTpjAoZNGauaKtd0VtCY8p77nZ4mHi8lxh3lAPvSAeqvQkMmz+jusqp2D
	M2Khi+yUAlIbXSynsI0Bw==
Message-ID: <33307c790809191457y3ebffa28xa6d9ab6431554618@mail.gmail.com>
Date: Fri, 19 Sep 2008 14:57:56 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: Unified tracing buffer
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>
In-Reply-To: <20080919144258.ac787fdf.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <20080919144258.ac787fdf.randy.dunlap@oracle.com>
X-GMailtapped-By: 172.24.198.81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Event ids are 16 bit, dynamically allocated.
>
> What are these (like)?

u16

Sorry, probably lots of implicit assumptions in there that I forgot to explain

> Arch-specific "word"?
> or some fixed-size-for-all-systems (so that trace buffers can be
> shared/used on other systems?)  Preferably the latter.

Mmmm. I don't see anything wrong with making it just 8 byte aligned, personally.
Steven - this was your thing?

>> Variable record length, header will start with length record.
>> Timestamps in fixed timebase, monotonically increasing (across all CPUs)
>
> what timestamp resolution?

ns is probably sufficient for output, but may need to be higher
internally to get
correct ordering of events across CPUs. So, as long as we record this in
the buffer header, the internal resolution shouldn't be critical. The text
print output ... I'd say ns? We can put it relative to wall time in there,
as long as we record it in the buffer header at trace start. I guess we should
document the buffer header ;-)
