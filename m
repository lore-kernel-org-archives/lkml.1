Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbYLMRpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbYLMRpB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 12:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYLMRox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 12:44:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:48483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbYLMRow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 12:44:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=J6bRJeCWO/8mcuVb60Ns/Hf8WrYLrrnBqJYHt48yEHkGOy4kv+22N11YoxBic3LmYH
         REg21nU+1JLKGubP8JuBhZwedSqr8W10Ws+U53rrdssks5dHdJbDpRbNbWn2JV3Aq4yg
         5Lvmyk88LI5MEoVcbrMfkZuSjF5u4fTz9rmTs=
Message-ID: <7c86c4470812130944s5d2898ffpa28878ee4f51936a@mail.gmail.com>
Date: Sat, 13 Dec 2008 18:44:50 +0100
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
       "David S. Miller" <davem@davemloft.net>,
       Papi <ptools-perfapi@cs.utk.edu>
In-Reply-To: <1229167048.13566.119.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
	 <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
	 <1229073834.12883.41.camel@twins>
	 <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>
	 <1229167048.13566.119.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

I don't think you understand what libpfm actually does and therefore
you rush to the wrong conclusion.

At its core, libpfm does NOT know anything about the perfmon kernel API.

I think you missed that, unfortunately.

It is a helper library which helps tool writer solves the event-> code
-> counter assignment problems.
That's it. It does not make any perfmon syscall at ALL to do that.
Proof is people have been using it on
Windows, I can also use it on MacOS.

Looking at your proposal, you think you won't need such a library and
that the kernel is
going to do all this for you. Let's go back to your kerneltop program:

KernelTop Options (up to 4 event types can be specified):

 -e EID    --event_id=EID     # event type ID                     [default:  0]
                                  0: CPU cycles
                                  1: instructions
                                  2: cache accesses
                                  3: cache misses
                                  4: branch instructions
                                  5: branch prediction misses
                                < 0: raw CPU events

Looks like I can do:

$ kerneltop --event_id=-0x510088

You think users are going to come up with 0x510088 out of the blue?

I want to say:

$ kerneltop --event_id=BR_INST_EXEC --plm=user

Where do you think they are going to get that from?

The kernel or a helper user library?

Do not denigrate other people's software without understanding what it does.


On Sat, Dec 13, 2008 at 12:17 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2008-12-12 at 18:42 +0100, stephane eranian wrote:
>> In fact, I know tools which do not even need a library.
>
> By your own saying, the problem solved by libperfmon is a hard problem
> (and I fully understand that).
>
> Now you say there is software out there that doesn't use libperfmon,
> that means they'll have to duplicate that functionality.
>
> And only commercial software has a clear gain by wastefully duplicating
> that effort. This means there is an active commercial interest to not
> make perfmon the best technical solution there is, which is contrary to
> the very thing Linux is about.
>
> What is worse, you defend that:
>
>> Go ask end-users what they think of that?
>>
>> You don't even need a library. All of this could be integrated into the tool.
>> New processor, just go download the updated version of the tool.
>
> No! what people want is their problem fixed - no matter how. That is one
> of the powers of FOSS, you can fix your problems in any way suitable.
>
> Would it not be much better if those folks duped into using a binary
> only product only had to upgrade their FOSS kernel, instead of possibly
> forking over more $$$ for an upgrade?
>
> You have just irrevocably proven to me this needs to go into the kernel,
> as the design of perfmon is little more than a GPL circumvention device
> - independent of whether you are aware of that or not.
>
> For that I hereby fully NAK perfmon
>
> Nacked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
>
>
>
