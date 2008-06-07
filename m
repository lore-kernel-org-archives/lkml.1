Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYFGUTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYFGUTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 16:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYFGUTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 16:19:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:55396 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbYFGUTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 16:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cyLNZU7YjkN8U6n6iHHyftsF8jMI37h2zVFi92cxbT9ryuTd3+ukU3/Np2q5DT1KtB
         TUetYVkb/Wacer3LpcH4DCOk2VGhnb8gP1mijZuCjQgZuRYtw1hJm2d6nQDT7es1lMmL
         95iYRqGiFtQDqWvccsTOrUubnqWfa+n5rZjg0=
Message-ID: <19f34abd0806071319h19893ad5kcf938e1067b2a752@mail.gmail.com>
Date: Sat, 7 Jun 2008 22:19:44 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] kmemcheck: don't track pages allocated with interrupts disabled
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <484AE5C9.9070306@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080607143242.GA2893@damson.getinternet.no>
	 <484AC165.7000702@firstfloor.org>
	 <19f34abd0806071115s3e50d662p190a65fa2f091c7b@mail.gmail.com>
	 <484AE5C9.9070306@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 9:47 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
>> Maybe we can do the splitting when kmemcheck is enabled for the first
>> time, either with the proc handler or at boot if kmemcheck=1 is passed
>> on the command line. Both of these contexts should/can be
>> !irqs_disabled(), I think.
>
> You could always split at boot when the CONFIG is enabled. I assume the
> CONFIG alone has already quite a lot of overhead and it will be only
> on in debug kernels and adding some more TLB misses shouldn't be really
> a problem. Using 2MB pages in kernel is merely  an optimization.

Actually, no, the CONFIG itself is now very low overhead. The only
thing we do is a very simple check in the slab allocator each time you
allocate or free an object (it's a couple of if()s, I doubt it would
show up in anything but microbenchmarks). These is also maybe two or
three calls for each page fault, but they return very quickly.

I didn't test, but this should be the only penalty of enabling the
CONFIG. Of course, once you pass kmemcheck=1 at boot it will be a
disaster :-)

But you are probably right nevertheless; the overhead of 4K pages
instead 2M is probably negligible in most cases.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
