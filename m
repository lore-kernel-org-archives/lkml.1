Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbYHFE3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbYHFE3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 00:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbYHFE3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 00:29:04 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37654 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752559AbYHFE3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 00:29:03 -0400
Date: Tue, 5 Aug 2008 23:28:56 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
Message-Id: <20080805232856.78dd50f7.pj@sgi.com>
In-Reply-To: <4899202B.6030303@qualcomm.com>
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>
	<20080802063900.6615e5ca.pj@sgi.com>
	<48948C3A.6050805@qualcomm.com>
	<20080802225127.2b0d138b.pj@sgi.com>
	<4895F3ED.4020805@qualcomm.com>
	<20080804010033.0d1b0549.pj@sgi.com>
	<48977E81.4040207@qualcomm.com>
	<20080804225636.541527e8.pj@sgi.com>
	<4898B873.6000308@qualcomm.com>
	<20080805180521.be7010e1.pj@sgi.com>
	<48991973.90109@qualcomm.com>
	<20080805222927.6dd95f5f.pj@sgi.com>
	<4899202B.6030303@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> ... the wrong part of my reply ...

Was the right part where you wrote:
> We'd actually be changing more things.

I also don't care that much how much code is changed;
if it must be changed, then change it to what is best,
which may not necessarily be the minimum change.

If an asynchronous sched domain rebuild is needed in
some places, then consider just using it everywhere,
rather than providing two code paths to rebuild, one
sync and one async.

Ask not how we got here; ask where we should be.

In particular, and in this specific case, having the
dual code paths really did make it a little more difficult
for me to understand the code, as evidenced by the back
and forth discussion on how to name the confusingly
similar functions.  Such naming controversies are usually
a sign of code duplication or improper factoring.

That additional difficulty in understanding this code
was a key factor in delaying my review of your code.
I'd look at it, my mind was glaze over, and I'd put
it aside for a few days.  This happened repeatedly.

Fine code is like fine art ... spare, elegant, compelling
in its expression.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
