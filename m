Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbXGYEKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbXGYEKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 00:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbXGYEKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 00:10:46 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:37626 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750709AbXGYEKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 00:10:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=dlCZAZEGqPB1qyRlYtH5k0Q6DGQOZy47e3jKgMq24yebzSafoVrKBgDb/Q+0CM5U1qT9Tn2wOXQ3LhKH1glfSNv4MQ88hNWDKNhs5mrOM1M68ugWCws6K4mGRG9KQ78c2dEjgl8rMj+bV2j2EI7wbOo6Gea4Ef1MQXFE0JXYeBY=  ;
X-YMail-OSG: Wawh3Y0VM1lHAL1XTsUsEx5_.Bj5cX.zwDpDLY7XEuQuR0bYeYPmzlPrvx5EQ0W8tE4kMT3Uig--
Message-ID: <46A6CD3D.8010507@yahoo.com.au>
Date: Wed, 25 Jul 2007 14:10:37 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered	unnecessarily
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>	 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>	 <alpine.LFD.0.999.0707231054290.3607@woody.linux-foundation.org>	 <1185270756.5439.256.camel@localhost.localdomain>	 <alpine.LFD.0.999.0707241021210.3607@woody.linux-foundation.org>	 <1185298932.6586.22.camel@localhost>	 <alpine.LFD.0.999.0707241108360.3607@woody.linux-foundation.org>	 <1185313061.5439.283.camel@localhost.localdomain>	 <1185314112.6586.93.camel@localhost> <1185316368.5439.293.camel@localhost.localdomain>
In-Reply-To: <1185316368.5439.293.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Tue, 2007-07-24 at 17:55 -0400, Trond Myklebust wrote:
> 
>>If you want to use bitops as spinlocks you should rather be using
>><linux/bit_spinlock.h>. That also does the right thing w.r.t.
>>pre-emption and sparse locking annotations.
> 
> 
> Heh, I didn't know about those... A bit annoying that I can't override
> them in the arch, I might be able to save a barrier or two here. Our

I guess the test_and_set_bit_lock / clear_bit_unlock will allow you to
override them in a way.

The big performance problem I see on my powerpc system is not the bit
spinlocks (open-coded or not), but the bit sleep locks.

Anyway, I'll finally send out the lock bitops patches again today...

-- 
SUSE Labs, Novell Inc.
