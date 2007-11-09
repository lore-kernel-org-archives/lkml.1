Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbXKIK7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbXKIK7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 05:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbXKIK7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 05:59:17 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:25227 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbXKIK7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 05:59:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dylZrlMFZXLdMjluvZ0FVUpDpavdAvgBrTJhZUCU9DxbbX1SWcemiXRABNv15Leob1UjZTn7VCld0a085ToQUs39CZgKqCay+Qt0sdr1KSGT42cLyBEZv5T6pQtcXDYIKgUugZmeFv/x7Pv96mBPG66NM1TN99RMLHOsR525SKE=
Message-ID: <b647ffbd0711090259u7f2f2f64qe8b6330e55d4b99f@mail.gmail.com>
Date: Fri, 9 Nov 2007 11:59:15 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [BUG]: Crash with CONFIG_FAIR_CGROUP_SCHED=y
Cc: sukadev@us.ibm.com, balbir@in.ibm.com,
       Containers <containers@lists.osdl.org>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dhaval@linux.vnet.ibm.com,
       "Ingo Molnar" <mingo@elte.hu>, efault@gmx.de
In-Reply-To: <20071109101437.GA22544@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071108234805.GA2240@us.ibm.com>
	 <20071109070214.GO3143@linux.vnet.ibm.com>
	 <b647ffbd0711090045o5ebf4681q78f939f5c1e71fe1@mail.gmail.com>
	 <20071109101437.GA22544@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2007, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> [ ... ]
>
>   As a solution to this problem, I moved sched_fork() call, which
>   initializes scheduler related fields on a new task, before
>   copy_namespaces(). I am not sure though whether moving up will
>   cause other side-effects. Do you see any issue?

Should be ok (IMHO and at first glance :-)

> - The second problem exposed by this test is that task_new_fair()
>   assumes that parent and child will be part of the same group (which
>   needn't be as this test shows). As a result, cfs_rq->curr can be NULL
>   for the child.

Would it be better, logically-wise, to use is_same_group() instead?
Although, we can't have 2 groups with cfs_rq->curr != NULL on the same
CPU... so if the child belongs to another group, it's cfs_rq->curr is
automatically NULL indeed.



-- 
Best regards,
Dmitry Adamushko
