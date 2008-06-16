Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYFPQez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYFPQez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYFPQes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:34:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:14976 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbYFPQer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=HzEYvXPGpxgsoRpkXh9P0G4V4lCDndPWAaFp1h2Yg/Wpr0NeE6846naPW7Sit8BHys
         Ag5bz1maGKjbTzf7+nih/j2ZVpElAUzDFj4foqq1OuW/JMPB/oT1ztP98DjGQwWwxtsM
         QbljcmjOyoRczMknpOYw/alVhc9EfJsO9ORAA=
Message-ID: <661de9470806160934j722341b5p36f6abe1af615093@mail.gmail.com>
Date: Mon, 16 Jun 2008 22:04:46 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: bharathravi1@gmail.com
Subject: Re: [PATCH] Delay accounting, fix incorrect delay time when constantly waiting on runqueue
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org,
       dhaval@linux.vnet.ibm.com, vatsa@in.ibm.com,
       "Madhava K R" <madhavakr@gmail.com>
In-Reply-To: <1213609261-9554-1-git-send-email-bharathravi1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213609261-9554-1-git-send-email-bharathravi1@gmail.com>
X-Google-Sender-Auth: 4db3cb6cf76a74db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 3:11 PM,  <bharathravi1@gmail.com> wrote:
> From: Bharath Ravi <bharathravi1@gmail.com>
>
> This patch corrects the incorrect value of per process run-queue wait time
> reported by delay statistics. The anomaly was due to the following reason.
> When a process leaves the CPU and immediately starts waiting for CPU on
> the runqueue (which means it remains in the TASK_RUNNABLE state), the time
> of re-entry into the run-queue is never recorded. Due to this, the waiting time
> on the runqueue from this point of re-entry upto the next time it hits the CPU
> is not accounted for. This is solved by recording the time of re-entry of a
> process leaving the CPU in the sched_info_depart() function IF the process will
> go back to waiting on the run-queue. This IF condition is verified by checking
> whether the process is still in the TASK_RUNNABLE state.
>
> The patch was tested on 2.6.26-rc6 using two simple CPU hog programs. The
> values noted prior to the fix did not account for the time spent on the
> runqueue waiting. After the fix, the correct values were reported back
> to user space.
>
> Signed-off-by: Bharath Ravi <bharathravi1@gmail.com>
> Signed-off-by: Madhava K R  <madhavakr@gmail.com>

Looks very good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Balbir
