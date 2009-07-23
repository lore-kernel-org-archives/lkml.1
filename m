Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZGWWR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZGWWR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 18:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZGWWRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 18:17:25 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31936 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbZGWWRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 18:17:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=CZq7CuG5DHBNXzgEPR+TvxzL+/wL//O531Ym0/n6JVjPuxMBVq3VJVHBAPDicGs/1
	AdMLZcU0gP2A798LGUQ8g==
MIME-Version: 1.0
In-Reply-To: <20090723075735.GA18878@in.ibm.com>
References: <20090723075735.GA18878@in.ibm.com>
Date: Thu, 23 Jul 2009 15:17:18 -0700
Message-ID: <b040c32a0907231517l265a9528w628d48fa3625e261@mail.gmail.com>
Subject: Re: CFS group scheduler fairness broken starting from 2.6.29-rc1
From: Ken Chen <kenchen@google.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6NMI0J7013584

On Thu, Jul 23, 2009 at 12:57 AM, Bharata BRao<bharata@linux.vnet.ibm.com> wrote:> Hi,>> Group scheduler fainess is broken since 2.6.29-rc1. git bisect led me> to this commit:>> commit ec4e0e2fe018992d980910db901637c814575914> Author: Ken Chen <kenchen@google.com>> Date:   Tue Nov 18 22:41:57 2008 -0800>>    sched: fix inconsistency when redistribute per-cpu tg->cfs_rq shares>>    Impact: make load-balancing more consistent> ....>> ======================================================================>                        % CPU time division b/n groups> Group           2.6.29-rc1              2.6.29-rc1 w/o the above patch> ======================================================================> a with 8 tasks  44                      31> b with 5 tasks  32                      34> c with 3 tasks  22                      34> ======================================================================> All groups had equal shares.
What value did you use for each task_group's share?  For very largevalue of tg->shares, it could be that all of the boost went to one CPUand subsequently causes load-balancer to shuffle tasks around.  Do yousee any unexpected task migration?
- Kenÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
