Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbXG1MhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbXG1MhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 08:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbXG1Mg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 08:36:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:8843 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbXG1Mgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 08:36:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jDXPK5+IQUkWYNV+uyPYYg41TsPUnl08nr4oljtJf+YRmewoJfbKz0coQhS1BAoKqYw0XeMgE7AXlBJJD7/RkWviYrG0qXbvgoe5rC9u8IaWXBKQSyNJ78ljUN6fX37KCjyJcM3jlzelDYTnC4Douw1xAkOnaRwM8CMIlAxPvxs=
Message-ID: <b647ffbd0707280536q4a7c5da3he3ec6e2a8a19fc00@mail.gmail.com>
Date: Sat, 28 Jul 2007 14:36:54 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: tim.c.chen@linux.intel.com
Subject: Re: Volanomark slows by 80% under CFS
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1185573687.19777.44.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185573687.19777.44.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/07, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> [ ... ]
> It may make sense to queue the
> yielding process a bit further behind in the queue.
> I made a slight change by zeroing out wait_runtime
> (i.e. have the process gives
> up cpu time due for it to run) for experimentation.

But that's wrong. The 'wait_runtime' might have been negative at this
point (i.e. a task is in the negative 'run-time' balance wrt the
'etalon' nice-0 task). Your change ends up helping such a task to
actually stay closer to the 'left most' element of the tree (or to be
it) and not "further behind in the queue" as your intention is.

I don't know Volanomark's details so refrain from speculating on why
this change "improves" benchmark results indeed (maybe some afected
tasks have
positive 'wait_runtime's on average for this setup).

If you want to make sure (just for a test) a yeilding task is not the
left-most (at least) for some short interval of time (likely to be <=
1 tick), take a look at yield_task_fair() in e.g. cfs-v15.

> Volanomark runs better
> and is only 40% (instead of 80%) down from old scheduler
> without CFS.

40 or 80 % is still a huge regression.


>
> Regards,
> Tim
>

-- 
Best regards,
Dmitry Adamushko
