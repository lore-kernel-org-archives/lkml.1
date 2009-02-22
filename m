Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbZBVRGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbZBVRGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbZBVRGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:06:35 -0500
Received: from mail-bw0-f167.google.com ([209.85.218.167]:41438 "EHLO
	mail-bw0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbZBVRGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:06:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xKbciO9AyRFWK8IlCf9jC2pxP+VL4ClZrsaim4lu6oBfFeCfJFnX525L4YpUW8IC+j
         elNGzckeaQ/023YmymMpRZrANGoEQkZv20DF8umdVgx6nBLy8SqLPMtK5k7lIW+QtJW5
         5CdAA+JJzzBoMCCP/olbbzpeVeYv74IcwUkYk=
MIME-Version: 1.0
In-Reply-To: <20090222170044.GC6003@nowhere>
References: <20090222135739.GA28619@damson.getinternet.no>
	 <20090222164419.GA28442@elte.hu> <20090222170044.GC6003@nowhere>
Date: Sun, 22 Feb 2009 18:06:32 +0100
Message-ID: <19f34abd0902220906l73751821u3051cda3542b0518@mail.gmail.com>
Subject: Re: [GIT PULL] kmemcheck updates for -tip
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/22 Frederic Weisbecker <fweisbec@gmail.com>:
> BTW, I just tested kmemcheck (without these fixes pulled) and encountered some
> troubles with the function graph tracer which hangs during the self tests.
> As well as a message from hrtimer which tells its interrupt is too slow.
>
> Well, I'm pulling latest -tip and will see.

Hm, yes. kmemcheck doesn't work well with ftrace -- you'd have to
disable tracing (i.e. removing the -pg option to gcc) for at least the
x86 page fault handler and the kmemcheck code. I had a patch to fix
this a while ago, but it's not very nice to exclude page faults from
ftrace.

I should make it depend on !FTRACE for now to prevent more
head-scratching from others. Thanks for testing!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
