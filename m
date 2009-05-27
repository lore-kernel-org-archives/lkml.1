Return-Path: <linux-kernel-owner+w=401wt.eu-S1763677AbZE0OiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763677AbZE0OiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760636AbZE0OiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:38:08 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:51221 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761084AbZE0OiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UyHxMzOiTkZFJNMcsriEWGVna8W+yeoWphgbZlDcrIaqXhoUIfO5BqXJRe4icMGMDE
         WaKgcj3+hekdE9sEVm1lDfnxuEO1E1LUClFwNiJhkhD/hCVSCTAc9bzLCadplm5YRFin
         TBJOp3urQ2ZqqP+7ilsOU0US/5+tiwqw2Js3Y=
MIME-Version: 1.0
In-Reply-To: <20090527072643.GA15000@elte.hu>
References: <20090527054317.GA31443@damson.getinternet.no>
	 <20090527072643.GA15000@elte.hu>
Date: Wed, 27 May 2009 16:38:07 +0200
Message-ID: <19f34abd0905270738r41abc15byc464133d184c24f7@mail.gmail.com>
Subject: Re: [GIT PULL] kmemcheck fixes for -tip
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/27 Ingo Molnar <mingo@elte.hu>:
[...]

> Pulled, thanks Vegard! There were a few conflicts with tip:master,
> due to ongoing work in other areas:
>
>    Merge branch 'kmemcheck'
>
>    Conflicts:
>        include/linux/ring_buffer.h
>        init/do_mounts.c
>        kernel/trace/ring_buffer.c
>
> I resolved them manually, you might want to double check them.

Thanks. There seems to have been one interaction with this old commit
from who knows what branch:

commit 899b5030558b8dc21a171e2e8129e0a93fb08860
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Apr 29 16:31:50 2008 +0200

    init: root mount fix

    Needs changelog

    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

I think this commit can get chucked now, as I provided what I believe
was the better workaround (to introduce a wrapper for getname() that
takes GFP flags: commits 30066967f86f8b31fb7aef1f0a2214ae8d5a4b80 and
1c4018089bc978fa1ec3fc69d220ba432b1f075b). But the code as it stands
will work as it should.

There's now also an indentation mismatch in
include/linux/ring_buffer.h, line 16, in struct ring_buffer_event.

Don't know how you'd prefer to solve these, if at all? Should I send
patches against tip/master?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
