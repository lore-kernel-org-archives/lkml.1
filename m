Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbXH1IdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbXH1IdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 04:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbXH1Icz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 04:32:55 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:60558 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753908AbXH1Icy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 04:32:54 -0400
To: balbir@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, npiggin@suse.de, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
Subject: Re: [-mm PATCH 5/10] Memory controller task migration (v7)
In-Reply-To: Your message of "Mon, 27 Aug 2007 16:09:15 +0530"
	<46D2A9D3.50703@linux.vnet.ibm.com>
References: <46D2A9D3.50703@linux.vnet.ibm.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070828083252.C7D5C1BFA2F@siro.lan>
Date: Tue, 28 Aug 2007 17:32:52 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> YAMAMOTO Takashi wrote:
> >> Allow tasks to migrate from one container to the other. We migrate
> >> mm_struct's mem_container only when the thread group id migrates.
> > 
> >> +	/*
> >> +	 * Only thread group leaders are allowed to migrate, the mm_struct is
> >> +	 * in effect owned by the leader
> >> +	 */
> >> +	if (p->tgid != p->pid)
> >> +		goto out;
> > 
> > does it mean that you can't move a process between containers
> > once its thread group leader exited?
> > 
> > YAMAMOTO Takashi
> 
> 
> Hi,
> 
> Good catch! Currently, we treat the mm as owned by the thread group leader.
> But this policy can be easily adapted to any other desired policy.
> Would you like to see it change to something else?
> 
> -- 
> 	Warm Regards,
> 	Balbir Singh
> 	Linux Technology Center
> 	IBM, ISTL

although i have no good idea right now, something which allows
to move a process with its thread group leader dead would be better.

YAMAMOTO Takashi
