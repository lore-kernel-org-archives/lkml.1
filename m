Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbXEBL4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbXEBL4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbXEBL4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:56:30 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41983 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbXEBL43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:56:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Howells <dhowells@redhat.com>
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: condingstyle, was Re: utrace comments
References: <m1y7k8x910.fsf@ebiederm.dsl.xmission.com>
	<alpine.DEB.0.98.0705011054060.12931@sigma.j-a-k-j.com>
	<20061127165138.GA2991@lst.de>
	<20070430040213.BF9901801A4@magilla.sf.frob.com>
	<20070430091121.GC31397@infradead.org>
	<20070430100917.439ebfc8.akpm@linux-foundation.org>
	<a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com>
	<Pine.LNX.4.64.0705011058330.27246@anakin>
	<1178028973.2875.78.camel@pmac.infradead.org>
	<9185.1178035627@redhat.com> <24844.1178098371@redhat.com>
Date: Wed, 02 May 2007 05:55:02 -0600
In-Reply-To: <24844.1178098371@redhat.com> (David Howells's message of "Wed,
	02 May 2007 10:32:51 +0100")
Message-ID: <m1fy6fxwx5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Not lining up with the code following the if statement is also
>> a plus.  Because it clearly delineates the conditions from the code.
>
> But the condition doesn't line up with the code:

Exactly.  The condition not lining up with the following code helps
code helps separate the two.

> 	if (veryverylengthycondition1 &&
> 	    smallcond2 &&
> 	    (conditionnumber3a ||
> 	     condition3b)) {
> 		this_is_some_code();
> 		this_is_some_more_code();
> 	}
>
> Personally, for complicated conditions like this, I prefer:
>
> 	if (veryverylengthycondition1 &&
> 	    smallcond2 &&
> 	    (conditionnumber3a ||
> 	     condition3b)
> 	    ) {
> 		this_is_some_code();
> 		this_is_some_more_code();
> 	}
>
> But that seems to offend Andrew for some reason (or was it Christoph? or
> both?).

Yes. 

Although I suspect simply not tucking the trailing brace is as
good or better.  I believe not putting the beginning brace at
the beginning of the line is a violation of coding style.

	if (veryverylengthycondition1 &&
	    smallcond2 &&
	    (conditionnumber3a ||
	     condition3b))
	{
		this_is_some_code();
		this_is_some_more_code();
	}


However there is the practical way to solve this if you have
a sufficiently large conditional, or the conditional appears
several times.

	static inline int test_func()
	{
		if (!veryverylengthycondition1)
                	return 0;
  		if (!smallcond2)
			return 0;
		if (conditionnumber3A)
			return 1;
		if (condition3b)
			return 1;
		return 0;
	}

	if (test_func()) {
        	this_is_some_code();
		this_is_some_more_code();
        }	

Eric
