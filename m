Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbXF0GUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbXF0GUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbXF0GUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:20:24 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:39950 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754982AbXF0GUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:20:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ZPPrI+Lz4tVW9RjQyZutwRtT997EE1s9lhTyefrShFPHoV6dGqL73h/y2wUqUgfZ72ngu6Oqid+qyLB7BKSyOFfYLr0n1D2X0ZRsocwtK6iQtpaxb10Tkau0+d1NLj8GZkkSZ5AHKFZZLOftLVTnx6AfJ2J4v3OSaISEniXDteM=  ;
X-YMail-OSG: hUVjgw0VM1np1D_5.gbqLn77TCqbW1OwCdfKB_ccXsXjME2QpfLzt67lAywx0_aaavWTp_XTKQ--
Message-ID: <468201A0.5010401@yahoo.com.au>
Date: Wed, 27 Jun 2007 16:20:16 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Jarek Poplawski <jarkao2@o2.pl>,
       Miklos Szeredi <miklos@szeredi.hu>, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <4680D162.9050603@yahoo.com.au> <alpine.LFD.0.98.0706261016200.8675@woody.linux-foundation.org> <4681F448.3040201@yahoo.com.au> <alpine.LFD.0.98.0706262249590.8675@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706262249590.8675@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 27 Jun 2007, Nick Piggin wrote:
> 
>>I don't know why my unlock sequence should be that much slower? Unlocked
>>mov vs unlocked add? Definitely in dumb micro-benchmark testing it wasn't
>>twice as slow (IIRC).
> 
> 
> Oh, that releasing "add" can be unlocked, and only the holder of the lock 
> ever touches that field?

Right.


> I must not have looked closely enough. In that case, I withdraw that 
> objection, and the sequence-number-based spinlock sounds like a perfectly 
> fine one.
> 
> Yes, the add will be slightly slower than the plain byte move, and the 
> locked xadd will be slightly slower than a regular locked add, but 
> compared to the serialization cost, that should be small. For some reason 
> I thought you needed a locked instruction for the unlock too.
> 
> So try it with just a byte counter, and test some stupid micro-benchmark 
> on both a P4 and a Core 2 Duo, and if it's in the noise, maybe we can make 
> it the normal spinlock sequence just because it isn't noticeably slower.
> 
> In fact, I think a "incb <mem>" instruction is even a byte shorter than 
> "movb $1,mem", and with "unlock" being inlined, that could actually be a 
> slight _win_.

OK, I'll try running some tests and get back to you on it.

-- 
SUSE Labs, Novell Inc.
