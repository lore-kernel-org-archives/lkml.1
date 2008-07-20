Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbYGTQip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbYGTQip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 12:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757537AbYGTQih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 12:38:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:21585 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421AbYGTQih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 12:38:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=lp2MkeTUMK36SZOufWlHDCrbts4x4FSrV/sY4bRaQ7VC4H2B1ivCpBAH32IHOdy8pA
         TxtvqU0npyyGHPWu/rfe3J9pHdhF67K4lkwtNYQdhpxLVoLEDQqJ04FP4NbFz8nJdLv3
         +v5e2vpgpvHMmeHXICa5Jwefmc/XfSq2iI5Is=
Message-ID: <4b6fba110807200938l5c210687j3910ca67acf887ca@mail.gmail.com>
Date: Sun, 20 Jul 2008 12:38:36 -0400
From: "Daniel Rosenthal" <danielrosenthal@acm.org>
To: linux-kernel@vger.kernel.org
Subject: scheduler code and task_struct
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 668d2b9b0eaab424
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm implementing a process scheduling algorithm (Sporadic Server,
SCHED_SPORADIC in POSIX) and there is some algorithm specific
per-process information that I have to maintain somewhere.  Also, the
algorithm must take more (per-process) parameters than just the int
sched_priority parameter in sched_param.  It looks like the most
appropriate place to put this information is in task_struct, this kind
of looseleaf information clutters it up.  Where should this
information go?  It seems like this dilemma affects more than just
this specific algorithm, but it would affect any more sophisticated
algorithms in the future which make use of more than just a priority
parameter and a timeslice for the currently running task.

What I've done so far is add a struct __sched_settings and struct
__sched_state to task_struct, which could be used by any scheduler
(both of these should perhaps be unions instead).  I've also added an
event queue to every runqueue that gets triggered on scheduler_tick()
and hrtick() since the algorithm has to maintain a list of execution
capacity replenishment events that are always scheduled to happen in
the future.  I'm not sure either of these are the most general or
extensible solution.  Any ideas (not just specifically for this
algorithm, but to provide more robust generic facilities for new
scheduling algorithms in the future)?

Please CC me personally in any replies because I'm not subscribed to
the mailing list.

Thanks,
Daniel
