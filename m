Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbYHSLE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbYHSLE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 07:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYHSLEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 07:04:20 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:33361 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751779AbYHSLET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 07:04:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=D/6dN5Gc8pzqmo0QdLfAYzHcEQF7I0fNFiFphg1niBJ2OHhVUqpbtxPrRhAn/ITzQqs2/Gzel9WilwAJmvk6qaYE/J+lJfP53E1+x30hUZ2OQ3oiDGQSgvGWkUJmMIzNoXQuKOTvD0UrTytu/jKD4OS0IrOFSD34vq50TZgybbE=  ;
X-YMail-OSG: koV3FsAVM1m6WXJFHodQuBWteoc41WZ6y9iicKHA1gFLBwCuvKoLyA3pkoXHq8ebxKprgBY3NBWGdPeU9dSBRE70agcp4A7FmjRPwCZiQnvElXL6q.em9bM1G2wH5vm6xek-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes to use function calls [POST 2]
Date: Tue, 19 Aug 2008 21:04:05 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
References: <patchbomb.1219083817@localhost> <200808191956.59898.nickpiggin@yahoo.com.au> <20080819103100.GH9807@one.firstfloor.org>
In-Reply-To: <20080819103100.GH9807@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192104.05322.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 August 2008 20:31, Andi Kleen wrote:
> > I'm especially sore about mmap because I have a customer with a
> > database that uses a lot of mmap/munmap and those calls have slowed
> > down something like 50%(!!) from 2.6.early to 2.6.late.
>
> These are small mmaps right? Also in this case no kmalloc should
> be needed anyways.

Yes, smallish mmaps. But larger ones weren't much better.


> AFAIK mmap flushing hasn't changed much in 2.6 and it tends
> to batch well anyways in this case (unlike vmscan swapping). I would be
> careful to really optimize the real culprits which are likely elsewhere.

It wasn't actually the TLB flushing side of it that was causing
the slowdown IIRC. It's just all over the map.

Notifier hooks; accounting statistics; 4lpt; cond_resched and
low latency code causing functions to spill more to stack; cache
misses from data structures increasing or becoming unaligned...

Basically just lots of little straws that added up to kill the
camel. I didn't even get to the bottom of the whole thing. But
my point is that even 1% here and there eventually adds up to a
big headache for someone. For some features it is obviously
inevitable to slowdown, but in all other cases we should always
be aiming to make the kernel faster rather than slower.
