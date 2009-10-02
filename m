Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbZJBMs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbZJBMs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757272AbZJBMs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:48:58 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:62275 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221AbZJBMs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nYWi/2bm3ZrvcwEiJIku+88BsAcCMbV2XqK8x5/y7dIfWnOTRDf22+b2WzxaWyN7yS
         TiHm2Sm+huw3HCc1ehnG0ZDzfvVTOxwrKDvHc4oGqGu6T8Ilp4Fuxr0AURUq3jgcK7jG
         fSyLPChHKLapHyCZlFtAC6yVkpFIdFTLF7XbM=
MIME-Version: 1.0
In-Reply-To: <4AC43118.6050409@ct.jp.nec.com>
References: <4AC43118.6050409@ct.jp.nec.com>
Date: Fri, 2 Oct 2009 14:49:00 +0200
Message-ID: <c62985530910020549q72cbb2fav43c4a6e191239b0c@mail.gmail.com>
Subject: Re: [PATCH] trace: fix missing assignment in trace_ctxwake_*
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/1 Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> The state char variable S should be reassigned, if S == 0.
>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>


Good catch, we are indeed missing the state of the task that is going to sleep
for the context switch events (in the raw mode).

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Fortunately the problem arises with the sched_switch/wake_up  tracers, not
the sched trace events.
The formers are legacy now. But still, that was buggy.

Thanks.
