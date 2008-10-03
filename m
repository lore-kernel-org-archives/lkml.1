Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYJCRVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYJCRVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYJCRVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:21:38 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:48777
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843AbYJCRVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:21:38 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RT PATCH v2 0/2] Series short description
To: Chirag Jog <chirag@linux.vnet.ibm.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, dvhltc@us.ibm.com, dino@in.ibm.com,
       Gilles.Carry@bull.net
Date: Fri, 03 Oct 2008 13:26:07 -0400
Message-ID: <20081003172221.23714.71575.stgit@dev.haskins.net>
In-Reply-To: <48E62253.1090000@bull.net>
References: <48E62253.1090000@bull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gilles Carry wrote:
> Sorry Greg,
>
> Neither PPC64 nor Intel64 make it with this patch.
> At boot time, it stops at the BUG_ON you added:
> 0xc00000000004eca4 is in push_rt_task (kernel/sched_rt.c:1102)
>


Indeed.  Your report has revealed the problem to me.

The issue is that there are three conditions embedded in that if(!lower_rq)
code, but two are buried in the !retry case.  This was the mistake I was making.

We basically need to 

a) dequeue if the task hasnt moved
b) retry if the task *has* moved AND there are more tasks left
c) stop of the task *has* moved AND there are no more tasks

I was missing logic to handle (c).  "v2" should fix this so it is handled.
Please give it a try.  Thanks again, Gilles!

(Again, only build-tested)

Regards,
-Greg


---

Gregory Haskins (2):
      RT: remove "paranoid" limit in push_rt_task
      RT: Remove comment that is no longer true


 kernel/sched_rt.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

-- 
Signature
