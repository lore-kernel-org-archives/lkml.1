Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbZGCTCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbZGCTCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbZGCTCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:02:11 -0400
Received: from mail-ew0-f215.google.com ([209.85.219.215]:52748 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbZGCTCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kCC1RGAkqR1W8cQim9C9TJ25nOANUGr0DtLa7yZ5pVsomyGa+B68PbawRKiIEWgjo6
         7C7piy+qi5O75Dd1sttVROsi4Q1dmdBN65u5Wx+w3S8L+elHpnGZaGgF6hX0KiKt+W6S
         yf9TrdCXSLprn/gGb63Mg+A+RBWX2rY0ZeCag=
Message-ID: <4A4E55A9.7090001@gmail.com>
Date: Fri, 03 Jul 2009 20:02:01 +0100
From: Dave <kilroyd@googlemail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090328)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Kilroy <kilroyd@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] check spinlock_t/rwlock_t argument type on non-SMP builds
References: <1246560291-8104-1-git-send-email-kilroyd@googlemail.com> <20090703073801.GA10191@elte.hu>
In-Reply-To: <20090703073801.GA10191@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * David Kilroy <kilroyd@googlemail.com> wrote:
> 
>> When writing code for UP without CONFIG_DEBUG_SPINLOCK it's easy 
>> to get the first argument to the spinlock/rwlock functions wrong. 
>> This is because the parameter is not actually used in this 
>> configuration.
>>
>> Typically you will only find out it's wrong
>>  * by rebuilding with CONFIG_SMP or CONFIG_DEBUG_SPINLOCK
>>  * after you've submitted your beautiful patch series.
>>
>> The first means a long wait, and the latter is a bit late.
>>
>> Add typechecking on the first argument of these macro functions. 
>> Note that since the typecheck now references the variable, the 
>> explicit read is redundant and can be removed.
>>
>> This change causes compiler warnings in net/ipv4/route.c, as this 
>> passes NULL as the first argument in the UP configuration. Simply 
>> cast this.
> 
> Wondering - can the wrappers be moved from CPP land to C land by 
> turning them into inlines? (i havent checked all usages so there 
> might be some surprises, but by and large it ought to be possible.)

I thought about doing it that way. I decided not to because I suspected
it would be harder to verify that the behaviour is unchanged.

Also the _lock_irqsave functions output to the flags parameter (which
isn't a pointer) so that has to remain a macro.

If you'd really rather an inline version, I can spend some time looking
into it.


Dave.
