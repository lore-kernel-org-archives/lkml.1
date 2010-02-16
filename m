Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab0BPRvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 12:51:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38898 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024Ab0BPRva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 12:51:30 -0500
Message-ID: <4B7ADB07.1050500@zytor.com>
Date: Tue, 16 Feb 2010 09:51:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: set_personality_ia32() abuses TS_COMPAT
References: <20100215161752.GA19962@redhat.com> <4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com> <4B79B202.5090006@zytor.com> <20100216101903.GA1057@redhat.com> <20100216102332.GL21783@one.firstfloor.org> <20100216140126.GA16448@redhat.com> <20100216140242.GC16448@redhat.com> <alpine.LFD.2.00.1002160738530.18830@localhost.localdomain> <20100216174437.GA28323@redhat.com>
In-Reply-To: <20100216174437.GA28323@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2010 09:44 AM, Oleg Nesterov wrote:
> On 02/16, Linus Torvalds wrote:
>>
>> And after we have switched to 32-bit mode, we _are_ inside a 32-bit system
>> call: the execve has "changed" from a 64-bit one to a 32-bit one.
>>
>> So I really don't understand why you dislike TS_COMPAT here.
> 
> and, following this logic, shouldn't set_personality_64bit() clear
> TS_COMPAT ?
> 

It's quite possible it should... I haven't dug into if that isn't either
done elsewhere or isn't done for some other reason.  This would be worth
looking into.

> OK, in any case I do not claim we need fixes. Just I am confused.

Trying to understand the code is good.  However, you seem to have
started out with a point of view that we should have the minimal set of
state changes possible instead of keeping state as self-consistent as
possible.  Invariants are a Very Good Thing.  Documented invariants are
even better ;)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

