Return-Path: <linux-kernel-owner+w=401wt.eu-S2992929AbXDDPYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992929AbXDDPYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992932AbXDDPYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:24:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:43965 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992929AbXDDPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nknBBJDMK//zTkjAWCIRgQVUq4nRtoCCuJeskc01S7h1bu43b/E+AUQ2GqOxtQ4ywpW9tVTcDqk/+bJKGoBp+Oa6ftigDIO8WbE+GWOYUDAz5mpUksl6td3xwHs0dQjmdx4dwmKVQFtT8xqUU+xVw4GdhKTpTeDtfAbztuzKmgQ=
Message-ID: <b647ffbd0704040823g51da1cb1ka59ad52a92231498@mail.gmail.com>
Date: Wed, 4 Apr 2007 17:23:59 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [sched] redundant reschedule when set_user_nice() boosts a prio of a task from the "expired" array
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070404141546.GA862@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
	 <20070404141546.GA862@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
> > [...]
> >
> > The same is applicable to rt_mutex_setprio().
> >
> > Of course, not a big deal, but it's easily avoidable, e.g. (delta < 0
> > && array == rq->active).
>
> i think you are right and a micro-optimization could be done here. Would
> you like to do a patch for this?

Yes, I'll do it.

in fact, "delta < 0 && array == rq->active" is also sub-optimal.

"TASK_PREEMPTS_CURR(p, rq) && array == rq->active" seems to be ok.. or
maybe even TASK_PREEMPTS_CURR() should internally check for "p->array
== rq->active"...

will come with some solution.

Thanks.

>
>         Ingo
>

-- 
Best regards,
Dmitry Adamushko
