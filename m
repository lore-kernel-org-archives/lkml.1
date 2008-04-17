Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbYDQFY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbYDQFY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 01:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYDQFYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 01:24:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44237 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYDQFYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 01:24:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=gaAknTh8wxRmQHQPRTUgy1Ua0G/TpolreA2JrMyPO9QWVNTvtVqTIPuyyoQ82dV3z
	JOrIXe+CjrO3DJPr2u9hw==
Message-ID: <6599ad830804162224s42ba221vea981fe34b30636a@mail.gmail.com>
Date: Wed, 16 Apr 2008 22:24:09 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup: fix a race condition in manipulating tsk->cg_list
Cc: "Li Zefan" <lizf@cn.fujitsu.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <20080416221655.c73d219f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4806C5EB.3040102@cn.fujitsu.com>
	 <6599ad830804162118g6b24d8ebq26b0d72133b0e19e@mail.gmail.com>
	 <4806DA6F.3000405@cn.fujitsu.com>
	 <20080416221655.c73d219f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 10:16 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>  > > Maybe it would be better to not do a cgroup_exit() until we're
>  > > unhashed, so that cgroup_enable_task_cg_list() can't find the exiting
>  > > task?
>
>  So we won't be doing what Paul suggested?
>

It's not as high a priority as Li's bug fix (which may be a good
candidate for 2.6.25.1) but for the future I think I'll implement this
distinguished css_set pointer for tasks that have finished
cgroup_exit(), since I think it will make the similar synchronization
in attach_task() cleaner, as well as cgroup_enable_task_cg_list().

Paul
