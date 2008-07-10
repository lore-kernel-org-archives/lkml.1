Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbYGJPnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbYGJPnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYGJPmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:42:54 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:42194 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYGJPmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:42:53 -0400
Date: Thu, 10 Jul 2008 21:12:37 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Rik Van Riel <riel@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Message-ID: <20080710154237.GD18228@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080701191126.GA17376@redhat.com> <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com> <20080703155446.GB9275@redhat.com> <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com> <20080710143018.GC3782@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710143018.GC3782@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> So it boils down to.
> 
> 1) Can we bear the delay in task classification (Especially, exec). If yes,
>   then all the classification job can take place in userspace.

The answer is not really.

> 
> 2) If no,
> 	a) Then either we need to implement rule based engine to let
> 	  kernel do classfication.
> 
> 	b) or we need to do various things in user space as you suggested.
> 		- Pur wrapper around applications.
> 		- Job launcher (ex. Grid daemon) is modified to determine
> 		  the right cgroup and place application there before
> 		  actually launching the job.
> 


I like this approach. The whole classification should really be done by
userspace. Let the wrapper move into the correct group and then start the
task. The kernel really is not the right place for the classification.

And you can have a default group for tasks who really don't care about
where they are placed.

-- 
regards,
Dhaval
