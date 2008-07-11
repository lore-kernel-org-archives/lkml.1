Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbYGKM2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbYGKM2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbYGKM2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:28:30 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:40648 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbYGKM2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:28:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=To:Date:From:Received:Subject:Mime-Version:Message-Id:Content-Transfer-Encoding:Content-Type:X-Abuse:X-Seznam-User:X-QM-Mark;
	b=I2YphLaXb+M6R12DbROFmointQOXGQeAgbxLmwLJIRPpPS5f5D+Cf5JLo1xttfQVy
	8+O2mhjxKNkwuuksWaIyMrQY5T5jOQYoNz7EORL/uPu+vAzov+Yw9ySTzXR8N6VLmK6
	J102e1rAjfKu2G6wmRRcc30UdZCeO6G6ZbPDgOE=
To: =?us-ascii?Q?Linux=20Kernel=20list?= <linux-kernel@vger.kernel.org>,
       mingo@elte.hu
Date: Fri, 11 Jul 2008 14:26:54 +0200 (CEST)
From: =?us-ascii?Q?Michal=20Simek?= <Monstr@seznam.cz>
Subject: =?us-ascii?Q?HR=20timers=3A=20?=
Mime-Version: 1.0
Message-Id: <4230.7013-20285-10295023-1215779214@seznam.cz>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset="us-ascii"
X-Abuse: abuse@seznam.cz
X-Seznam-User: Monstr@seznam.cz
X-QM-Mark: email-qm5<141656233>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I debug Microblaze kernel and I found one big problem which comes with your patch.
Here is more detail about patch (latest patch linux/kernel/git/torvalds/linux-2.6.git/include/linux/seqlock.h)

author	Ingo Molnar <mingo@elte.hu>
	Thu, 3 Apr 2008 07:06:13 +0000 (09:06 +0200)
committer	Ingo Molnar <mingo@elte.hu>
	Thu, 24 Apr 2008 22:25:08 +0000 (00:25 +0200)
commit	88a411c07b6fedcfc97b8dc51ae18540bd2beda0

You add there checking mechanism to (read_seqbegin and read_seqcount_begin) where you are checking
odd value in ret variable. I don't know yet why I got there odd  value (0x3553). What does it mean the odd bit here?
I read any comment about tick_oneshot code. 

Could you explain me what is broken?

Thanks for your help,
Michal Simek

 static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 {
-       unsigned ret = sl->sequence;
+       unsigned ret;
+
+repeat:
+       ret = sl->sequence;
        smp_rmb();
+       if (unlikely(ret & 1)) {
+               cpu_relax();
+               goto repeat;
+       }
+
        return ret;
 }
