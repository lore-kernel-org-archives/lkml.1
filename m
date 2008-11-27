Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYK0MbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYK0MbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYK0MbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:31:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:51831 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbYK0MbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=iTtuoRvIIxaP+3dzNDWBNLPT3iBwDw0ezsY0aihuMBDqAuZ/qy4zpIu2mFv/rMLhDF
         lkERfBq5Ky0Dq03i3mTNamA0+VxcPyhU1dNsOkxWUHAFN/wkl8UlrU55AilR5giH7YAw
         FikLOam+p9SJ7X5d4D0S6EJyG5aA4JYO3AldA=
Message-ID: <7c86c4470811270431n5cf1b863tc4f8c7829283e332@mail.gmail.com>
Date: Thu, 27 Nov 2008 13:31:08 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
In-Reply-To: <20081127123811.GJ6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>
	 <20081127113115.GH6703@one.firstfloor.org>
	 <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com>
	 <20081127.034247.72331360.davem@davemloft.net>
	 <alpine.LFD.2.00.0811271246200.3325@localhost.localdomain>
	 <20081127123811.GJ6703@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 1:38 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Thu, Nov 27, 2008 at 12:49:37PM +0100, Thomas Gleixner wrote:
>> On Thu, 27 Nov 2008, David Miller wrote:
>>
>> > From: "stephane eranian" <eranian@googlemail.com>
>> > Date: Thu, 27 Nov 2008 12:35:54 +0100
>> >
>> > > I am still wondering how Oprofile handles the case where multiple
>> > > processes or threads access the same file descriptor.
>> >
>> > There's only one profiling buffer active on a given cpu,
>> > so it's pure per-cpu value insertion.
>> >
>> > In any event I think that NMI profiling is a must, especially
>> > for the kernel.  You get total unusable crap otherwise.  I
>> > just learned this the hard way having gotten an NMI'ish scheme
>> > working on sparc64 just the other day.
>>
>> Not arguing about that, I'm just not agreeing with the implementation.
>>
>> So for the moment we can go w/o the NMI and implement it cleanly after
>> we got the initial lot in.
>
> Note once Stephane readds PEBS support (it is currently stripped out)
> you'll be also able to get somewhat reasonable results at least on modern
> Intel x86 without NMI profiling. But longer term it is still
> very useful because PEBS has some drawbacks too

That's true for Intel.
On AMD64, I think you can get at most one sample out of a irq-off
region using IBS.
