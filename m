Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbXDDOEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbXDDOEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 10:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbXDDOEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 10:04:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:48460 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbXDDOED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 10:04:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=awLXBYgYUOBANNS8dZr1j1CF50p7gNmVj3KV4hsRYqD5bF7ZzcmGOtZ+I6eD+ulMZgIbd/qxooIqj/ZVNkeBm/dG0rNWmWxg4CkaPA6HzAF/aCOG/9iwK81mSvssGhE/wm4kcPGhf/FwtcC0mTmCUtW9bV09bUHehSYNuCKoDfQ=
Message-ID: <b647ffbd0704040704k2e4b3abcyfadc7662dff37f5b@mail.gmail.com>
Date: Wed, 4 Apr 2007 16:04:02 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: [sched] redundant reschedule when set_user_nice() boosts a prio of a task from the "expired" array
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Scenario:

Currently running [task1] boosts a priority (lowers a static_prio) of
[task2] via { setpriority -> set_user_nice } and [task2] happens to be
in the "expired" array at the moment.

According to the set_user_nice(), "delta" is negative (the prio is
boosted) and, hence, resched_task(rq->curr) is called.

As the [task2] is in the "expired" array and there are still tasks (at
least [task1]) in the "active" one, the triggered reschedule is just
useless (e.g. gets control back to [task1]).

Am I missing something?

The same is applicable to rt_mutex_setprio().

Of course, not a big deal, but it's easily avoidable, e.g. (delta < 0
&& array == rq->active).

Thanks in advance for any comments.

-- 
Best regards,
Dmitry Adamushko
