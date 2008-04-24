Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbYDXQ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbYDXQ3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYDXQ30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:29:26 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:19505 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbYDXQ3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:29:25 -0400
Message-ID: <4810B55A.3090701@hp.com>
Date: Thu, 24 Apr 2008 12:29:14 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: davecb@sun.com, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
References: <480F8936.5030406@hp.com> <87ve27gz4u.fsf@basil.nowhere.org> <67E36C56-E149-4C87-8788-05BA43C1C2AD@kernel.dk> <4810961A.4000104@firstfloor.org> <20080424150425.GD12774@kernel.dk> <4810ACEA.5070401@sun.com>
In-Reply-To: <4810ACEA.5070401@sun.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Collier-Brown wrote:
> Jens Axboe wrote:
>> On Thu, Apr 24 2008, Andi Kleen wrote:
>>
>>>> Not a good idea IMHO, it's much better with an explicit setting. That
>>>> way you don't introduce indeterministic behavior.
>>>
>>> So you would be deterministically slower.
>>
>>
>> Yes, absolutely. Think about the case for a second - the potential
>> gain is in
>> fractions of a percent basically, the potential loss however is HUGE.
>> There's absolutely no way on earth I'd ever make this dynamic.
> 
>  If this is intended for databases, it might be backwards (;-))
>  The commercial unix "forcedirectio" option that Oracle and other
> database vendors usually ask for turns out to be a benefit
> in large sequential data transfers, because it does two things:
> 
> 1) transfers directly between user address space and disk, avoiding
> buffering, and
> 2) allows enthusiastic coalescence of synchronous writes
> 
>  Is this intended for DBMSs, or for something esle?
> 
> --dave

No, it's intended for devices being used for /random IO loads/ - like
index seeks during OLTP and the like. But in general, the idea is if you
know you have a highly random IO work load, you can set the tunable and
get back a significant chunk of CPU cycles.

Alan
