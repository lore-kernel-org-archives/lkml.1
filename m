Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbYLLJAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbYLLJAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYLLI77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 03:59:59 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:44811 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbYLLI76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:59:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=QNHNxtNjMZ2PB4O1VWJKY5lrhWDIlqa4xwjYTdqLeTfRml1x3JWmv6sxsD1c7RXxxQ
         7WyNAfNbaBTQxm5kP+DuGXtd5tNMhqByNy5AaBxnZaYHAFxDL7Kg9qgy4RjI2Elw1TmB
         63euhvvWJEpGfQRZ5J4K4uDupCddSa3kCDiBk=
Message-ID: <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
Date: Fri, 12 Dec 2008 09:59:56 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [patch] Performance Counters for Linux, v3
Cc: "Vince Weaver" <vince@deater.net>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>, "Paul Mackerras" <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1229070345.12883.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Fri, Dec 12, 2008 at 9:25 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2008-12-11 at 13:02 -0500, Vince Weaver wrote:
>

>> Perfmon3 works for all of those 60 machines.  This new proposal works on a
>> 2 out of the 60.
>
> s/works/is implemented/
>
>> Who is going to add support for all of those machines?  I've spent a lot
>> of developer time getting prefmon going for all of those configurations.
>> But why should I help out with this new inferior proposal?  It could all
>> be another waste of time.
>
> So much for constructive critisism.. have you tried taking the design to
> its limits, if so, where do you see problems?
>
People have pointed out problems, but you keep forgetting to answer them.

For instance, people have pointed out that your design necessarily implies
pulling into the kernel the event table for all PMU models out there. This
is not just data, this is also complex algorithms to assign events to counters.
The constraints between events can be very tricky to solve. If you get this
wrong, this leads to silent errors, and that is really bad.

Looking at Intel Core, Nehalem, or AMD64 does not reflect the reality of
the complexity of this. Paul pointed out earlier the complexity on Power.
I can relate to the complexity on Itanium (I implemented all the code in
the user level libpfm for them).  Read the Itanium PMU description and I
hope you'll understand.

Events constraints are not going away anytime soon, quite the contrary.

Furthermore, event tables are not always correct. In fact, they are
always bogus.
Event semantics varies between steppings. New events shows up, others
get removed.
Constraints are discovered later on.

If you have all of that in the kernel, it means you'll have to
generate a kernel patch each
time. Even if that can be encapsulated into a kernel module, you will
still have problems.

Furthermore, Linux commercial distribution release cycles do not
align well with new processor
releases. I can boot my RHEL5 kernel on a Nehalem system and it would
be  nice not to have to
wait for a new kernel update to get the full Nehalem PMU event table,
so I can program more than
the basic 6 architected events of Intel X86.

I know the argument about the fact that you'll have a patch with 24h
on kernel.org. The problem
is that no end-user runs a kernel.org kernel, nobody. Changing the
kernel is not an option for
many end-users, it may even require re-certifications for many customers.

I believe many people would like to see how you plan on addressing those issues.
