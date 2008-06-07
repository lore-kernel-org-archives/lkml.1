Return-Path: <linux-kernel-owner+w=401wt.eu-S1763755AbYFGSST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763755AbYFGSST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 14:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761084AbYFGSSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 14:18:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:51993 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760174AbYFGSSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 14:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=c1tMpdu+lVUVJ2l8Cb5a2YvfqKq6kyvpAPopdV+dO0Atm+iZ/bAUM/mUyllpqPgxi8
         PqnKiYwaWHIL7k1aFqDceBgBjNxfiZdtHi8CLDnRTlEUhWvOYFHjBiINtcsxw6DzHt14
         N+wHDq/yEYB00raAC6fuFFtWDTfXWhDLpxFlc=
Message-ID: <19f34abd0806071118j1089d940r42440abbcf7e9829@mail.gmail.com>
Date: Sat, 7 Jun 2008 20:18:11 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] kmemcheck: don't track pages allocated with interrupts disabled
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <484AC165.7000702@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080607143242.GA2893@damson.getinternet.no>
	 <484AC165.7000702@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 7:12 PM, Andi Kleen <andi@firstfloor.org> wrote:
> But a far better solution is to just split all the pages in  the system
> with set_memory_4k() at boot time  (and memory hot add time) when you
> know you're not in interrupt context.
>
> I believe that would be the right solution for DEBUG_PAGEALLOC too.

Ah, this is very true for more than one reason. We only ever touch
kernel pages with kmemcheck. So this means that userspace can still
use large pages and save memory with that. This wouldn't work when we
disable PSE entirely.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
