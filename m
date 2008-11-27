Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYK0Nrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYK0Nrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYK0NrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:47:24 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:61870 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYK0NrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:47:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=HZ5vUUPjlAo+w+rd0tSsPTUI+Co1n5BW2gc5eEFvHv6pAamm62pJ/z3hBUaHZv+0BF
         RYCUiXc5XuYl7rJ5bFcp0TuiNjqc3cUDalevN0bJujLcgBSre+VFL08MWH1ebWvtKHB6
         xKHx5JUgO9HPFLxoZbBEeEy2L986BwVh7xv/0=
Message-ID: <7c86c4470811270547y370e0be6keef6aadffa16581f@mail.gmail.com>
Date: Thu, 27 Nov 2008 14:47:20 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Cc: "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
In-Reply-To: <20081127134932.GN6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081126140054.GX6703@one.firstfloor.org>
	 <20081127100602.GF6703@one.firstfloor.org>
	 <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>
	 <20081127113115.GH6703@one.firstfloor.org>
	 <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com>
	 <20081127123257.GI6703@one.firstfloor.org>
	 <7c86c4470811270428r76702954se8f6e005481a6a35@mail.gmail.com>
	 <20081127124501.GL6703@one.firstfloor.org>
	 <7c86c4470811270530j4f3c5413j9e6e68cee08631a9@mail.gmail.com>
	 <20081127134932.GN6703@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 2:49 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> What about a thread doing this and another one in the middle of read the buffer?
>
> I assume that uses locks. Locking between threads is easy.
>
I think that is fine as long as the interrupt handler does not need to
grab locks.
But that, in turn, means that the state needed/modified by the handler cannot
be altered in any other way that could be harmful.

>>
>> Or what about a thread trying to reset the buffer while you're processing an PMU
>> interrupt on another CPU. I know each buffer is per-CPU, but that does not
>> prevent two threads for trying to operate on it at the same time from
>> different CPUs.
>
> That happens per CPU.
>
So you're saying a thread can only access the buffer from the CPU it
is running on?
