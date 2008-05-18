Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbYERLbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbYERLbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 07:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYERLbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 07:31:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:25290 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbYERLbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 07:31:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lG+laFRom3kg0K7wr8oGqtTgNmvqc8fSiq74SIIr3biTbRZmaxwsuQADMlWJEQW8V/4HH9QKTxn0UKk9Ajs1/twtcDwJCKtMXRjQkySDDrIsOcUFKrfwmIn1G3bqantHSreDd2ZMk2/HFS+X8jHSWn138RxoyGtcyZ45uPLPDvc=
Message-ID: <19f34abd0805180431r15ed93bbk68f5313bdeaa255a@mail.gmail.com>
Date: Sun, 18 May 2008 13:31:41 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] kmemcheck: support for x86_64
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@linux.intel.com>
In-Reply-To: <48300248.7050701@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080517230458.GA18588@damson.getinternet.no>
	 <48300248.7050701@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 12:17 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
>> Most of them look something like this:
>>
>> kmemcheck: Caught 8-bit read from freed memory (ffff81000780a904)
>> ifffffffifffffffifffffffifffffffifffffffifffffffifffffffifffffff
>>     ^
>>
>> and my theory so far is that X86_64 uses some currently unhandled
>> instruction set extensions like MMX, SSE, etc. (Not 3DNow! because we
>> have a dependency for that), for a fairly common operation
>
> No it shouldn't. Only SSE users are in the (broken) MD RAID code
>
> Most likely you don't decode REX correctly in some cases.

Thanks. You are right, but you are wrong.

All those #ifdef X86_64 should of course be CONFIG_X86_64... So none
of the 64-bit code was being compiled in. Good spotting, Vegard! :-(


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
