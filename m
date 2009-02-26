Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbZBZTFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbZBZTFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZBZTFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:05:20 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:9642 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbZBZTFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:05:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RKAFvbqKJk0AtPucVZt9Acw2C0v4tAlqNRlYyQArWZGCQjM+Hid4QRRq0mNIOgBVju
         Ibm0pTS0uwb4ZNKuzLXEq6EQX0/zj4SqydNcjotHW8UCmicGZK3/jKkxdBUrzJIrJHak
         4wW2pKJxoYvwmYYhT1EFdEQCYH+NCeSpKzsH0=
Date: Thu, 26 Feb 2009 20:05:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/3] add binary printf
Message-ID: <20090226190511.GB6658@nowhere>
References: <49a38304.0506d00a.1f4b.406d@mx.google.com> <20090226130243.GA22460@elte.hu> <20090226170524.GB5889@nowhere> <20090226174303.GC29439@elte.hu> <20090226174547.GC5889@nowhere> <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere> <20090226185208.GA6658@nowhere> <20090226185635.GA12895@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226185635.GA12895@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 07:56:35PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Instead of calling the in/out helper from the decoder, why not 
> > calling the decoder from these three functions and let them 
> > take the appropriate actions for each decoded format token?
> > 
> > Naive example:
> > 
> > bstr_printf() {
> > 	while (decode_format(...))
> > 		if (type == number)
> > 			read_number_from_buf()
> > 			str = number(....)
> > 		....
> > }
> > 
> > vsnprintf {
> > 	while (decode_format(...))
> > 		if (type == number)
> > 			var_arg(...)
> > 			str = number(....)
> > 		....
> > }
> > 
> > vbin_printf {
> > 	while (decode_format(...))
> > 		if (type == number)
> > 			var_arg(...)
> > 			write_number_to_buffer()
> > 		...
> > }
> > 
> > And the standard in/out pieces can be invoked through helpers.
> 
> ok, that looks rather clean too. And maybe vsnprintf() and 
> bstr_printf() could be further unified?


Yes, read process can be unified between vbin_printf and vsnprintf
and write process can be unified between bstr_printf and vsnprintf,
both further than the above example.


> I guess it depends on how it all looks like in the end. Only one 
> way to find out ...


Let's try, the practice will tell us more, I'm on it.

Thanks.

> 	Ingo

