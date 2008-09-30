Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbYI3MjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbYI3MjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYI3MjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:39:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:10300 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYI3MjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MpTLZs1qeYdko4u+AyNSIP4StT5bDOLt54AwFzi+NjZMhQvJpf4BAZIWeIyjfCPDu4
         oVsCQsqc9nhoKnTBR8usNwzGQqmnkqb+atfLd5V+XwwO9dEde1a9B0DZ5gFCuWDKLWBQ
         koo3k/t44M26sTXR39TmSJgdQpGds/dh1Gjk0=
Message-ID: <c62985530809300539o2842c14fk16708abaf69c4e2f@mail.gmail.com>
Date: Tue, 30 Sep 2008 14:39:06 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH V2 -tip 3/4] Tracing/ftrace: Adapt mmiotrace to the new type of print_line
Cc: "Pekka Paalanen" <pq@iki.fi>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
In-Reply-To: <20080930085241.GB10374@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48E11E1E.7010001@gmail.com>
	 <20080929221934.260306dd@daedalus.pq.iki.fi>
	 <20080930085241.GB10374@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/30 Ingo Molnar <mingo@elte.hu>:
> thanks guys!
>
> Steve's latest trace-ringbuffer code against -tip complicates life a
> little bit.
>
> We dont yet know whether tip/tracing/ring-buffer is ready for wider
> consumption, so it's in a separate feature branch. These four patches
> conflict with the ring-buffer code quite widely.
>
> So ... i did an optimistic merge approach: i merged these 4 patches
> ontop of the new tip/tracing/ring-buffer code, and have put it into a
> new tip/tracing/pipe branch:
>
>  # f19d495: tracing/ftrace: adapt the boot tracer to the new print_line type
>  # 92261f6: tracing/ftrace: adapt mmiotrace to the new type of print_line
>  # 157190e: tracing/ftrace: fix pipe breaking
>  # 92e359a: tracing/ftrace: change the type of the print_line callback
>
> i'm merging this into tip/master for a bit of testing, but if it breaks
> something (or if i havent pushed it out yet) you can merge it locally
> too, by doing this ontop of tip/master:
>
>  git-merge tip/tracing/pipe
>
> it should merge up cleanly and you should be able to check the end
> result. (and send me any fixes for merge mistakes)
>
> ( Once it's all in reasonably well-tested shape it will all show up in
>  tip/master and you can stop dealing with tip/tracing/* sub-branches.)
>
>        Ingo
>

Thanks Ingo.

I'm currently testing tip/master, since tracing/pipe is merged into.
It seems there are some locking issues that I hadn't when I tested the patches.
Perhaps it's because of the merge with the new ring buffer.

I just launched the sched_switch tracer and it worked well until 4
seconds of execution. And after that it blocked.
I tested too a marker message adding and it is never displayed. Worse:
I can't break the pipe with Ctrl + C after that.

When I will have some time, I will try to debug all what I find.
