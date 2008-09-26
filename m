Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYIZTqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYIZTqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYIZTqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:46:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54687 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYIZTqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:46:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=NBcUiXZrNtyDZHUsRxZrfxeAOs8zUVnLEIwcY4UC8ZFGs5VGhS398k1UqVC40Kb2p
	q97hwVpXE8+Y9CBWefPrg==
Message-ID: <33307c790809261246o47148443j49fee9197d18a3f1@mail.gmail.com>
Date: Fri, 26 Sep 2008 12:46:23 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH v6] Unified trace buffer
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "David Wilder" <dwilder@us.ibm.com>, hch@lst.de,
       "Christoph Hellwig" <hch@infradead.org>,
       "Masami Hiramatsu" <mhiramat@redhat.com>,
       "Steven Rostedt" <srostedt@redhat.com>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
In-Reply-To: <1222455557.16700.285.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080925185154.230259579@goodmis.org>
	 <20080925185236.244343232@goodmis.org>
	 <alpine.DEB.1.10.0809252101080.8124@gandalf.stny.rr.com>
	 <48DC406D.1050508@redhat.com>
	 <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com>
	 <1222455557.16700.285.camel@lappy.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 11:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2008-09-26 at 14:05 -0400, Steven Rostedt wrote:
>
>> +struct buffer_page {
>> +     u64             time_stamp;
>> +     unsigned char   body[];
>> +};
>> +
>> +#define BUF_PAGE_SIZE (PAGE_SIZE - sizeof(u64))
>
> Since you're already using the page frame, you can stick this per page
> timestamp in there as well, and get the full page for data.
>
> You can either use a struct page overlay like slob does, or add a u64 in
> the union that contains struct {private, mapping}.

What did you guys think of Mathieu's idea of sticking the buffer length
in the header here, rather than using padding events? Seemed cleaner
to me.
