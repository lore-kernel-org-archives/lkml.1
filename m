Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbYHUQWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbYHUQWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbYHUQVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:21:43 -0400
Received: from il.qumranet.com ([212.179.150.194]:15207 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbYHUQVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:21:42 -0400
Message-ID: <48AD9614.6060701@qumranet.com>
Date: Thu, 21 Aug 2008 19:21:40 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 	2.6.27-rc4	released
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com>	 <48AD5A21.7020801@s5r6.in-berlin.de>	 <43593.166.70.238.46.1219321595.squirrel@webmail.wolfmountaingroup.com>	 <200808212337.38626.nickpiggin@yahoo.com.au> <1219327799.8651.134.camel@twins>
In-Reply-To: <1219327799.8651.134.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Not sure - I think all barrier clobber the full register and memory set.
> So if you access a variable after a barrier it will have to issue a
> load.
>   

IIRC a barrier only clobbers memory.  gcc must reload a variable from 
memory unless it can prove the variable's address has not escaped anywhere.

So:

void f()
{
    int v;

    v = g();
    barrier();
    do_domething_with(v);
}

Need not reload v from memory (indeed, v can be in a register for its 
entire lifetime), but

void f()
{
    int v;

    v = g();
    h(&v);
    barrier();
    do_domething_with(v);
}
 
Will force v into memory, and reload it after the barrier.

-- 
error compiling committee.c: too many arguments to function

