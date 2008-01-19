Return-Path: <linux-kernel-owner+w=401wt.eu-S1764134AbYASBkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764134AbYASBkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbYASBkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:40:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:52187 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143AbYASBkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:40:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AzBxG2CaXCwKbuHJfxhHOMDge1OuiIkiWECS41NFVLsd8TWQ+jwKWAf3KIQmakZqvhYYtJejHMv15rzLQMmKBJKxYOOJFBNyyyvN1k05OQpn9NJFza8A/+4dCoqxJewcmLOn3TnWNio/6UNtDacdjTi3MtTEp2mAD0+4KYeQ7fs=
Message-ID: <47915515.1020905@gmail.com>
Date: Sat, 19 Jan 2008 10:40:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Ash Willis <ashwillis@programmer.net>,
       linux-pcmcia@lists.infradead.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] Makes lguest's irq handler typesafe
References: <200801190722.26154.rusty@rustcorp.com.au> <200801190727.36567.rusty@rustcorp.com.au> <47913261.5000708@gmail.com> <200801191228.30363.rusty@rustcorp.com.au>
In-Reply-To: <200801191228.30363.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

Rusty Russell wrote:
> On Saturday 19 January 2008 10:12:33 Tejun Heo wrote:
>> Type safety is good but I doubt this would be worth the complexity.  It
>> has some benefits but there's much larger benefit in keeping things in
>> straight C.  People know that functions take fixed types and are also
>> familiar with the convention of passing void * for callback arguments.
>> IMHO, staying in line with those common knowledges easily trumps having
>> type checking on interrupt handler.
> 
> I sympathise with this argument, but I think just because people are familiar 
> with existing hacks shouldn't prevent improvement.  I think the resulting 
> code is clearer and more readable.
> 
> Even in the implementation, the tricky part is the check_either_type() macro: 
> the rest is straight-forward.

The change is a small one and both the cost and benefit aren't big.

>> Also, how often do we see a bug where things go wrong because interrupt
>> handler is given the wrong type of argument?  Even when such bug
>> happens, I doubt it can escape the developer's workstation if he/she is
>> paying any attention to testing.
> 
> I agree this one is unlikely.  But I am trying to spread type-safety more 
> widely (see previous kthread patches).
> 
> I like changing the kernel to make life simpler for developers.  We don't do 
> enough of it.

I'm in full agreement here but the cost / benefit equation doesn't seem
quite right to me.  If we're gonna convert all callbacks to take native
pointers, I'm fine with the irq handler part too.  If not, it just adds
confusion which is much worse than any benefit it can bring, so I think
the question is "do we want to change all callbacks to take native
pointer type instead of void pointer?".

-- 
tejun
