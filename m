Return-Path: <linux-kernel-owner+w=401wt.eu-S1751364AbXCOLYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbXCOLYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 07:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbXCOLYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 07:24:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45933 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbXCOLYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 07:24:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=eh80jQ+RLOkUSJh8g9eHTfISTSlceUSDr9ugRG1eLcUXyYqGkH73glVXwPf3q+xCH
	AR4r42g41dBVQVLGH3uiw==
Message-ID: <6599ad830703150424t3478cd55mf9d2699f3669c9f0@mail.gmail.com>
Date: Thu, 15 Mar 2007 04:24:37 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: Summary of resource management discussion
Cc: xemul@sw.ru, dev@sw.ru, pj@sgi.com, sam@vilain.net, ebiederm@xmission.com,
       winget@google.com, serue@us.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ckrm-tech@lists.sourceforge.net,
       containers@lists.osdl.org
In-Reply-To: <20070312124226.GD17151@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070312124226.GD17151@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
>         - (subjective!) If there is a existing grouping mechanism already (say
>           tsk->nsproxy[->pid_ns]) over which res control needs to be applied,
>           then the new grouping mechanism can be considered redundant (it can
>           eat up unnecessary space in task_struct)

If there really was a grouping that was always guaranteed to match the
way you wanted to group tasks for e.g. resource control, then yes, it
would be great to use it. But I don't see an obvious candidate. The
pid namespace is not it, IMO. Resource control (and other kinds of
task grouping behaviour) shouldn't require virtualization.

>
> a. Paul Menage's patches:
>
>         (tsk->containers->container[cpu_ctlr.subsys_id] - X)->cpu_limit

Additionally, if we allow mature container subsystems to have an id
declared in a global enum, then we can make the cpu_ctlr.subsys_id
into a constant.

>
> b. rcfs
>         tsk->nsproxy->ctlr_data[cpu_ctlr.subsys_id]->cpu_limit

So what's the '-X' that you're referring to

> 3. How are cpusets related to vserver/containers?
>
>         Should it be possible to, lets say, create exclusive cpusets and
>         attach containers to different cpusets?

Sounds reasonable.

>
> 6. As tasks move around namespaces/resource-classes, their
>    tsk->nsproxy/containers object will change. Do we simple create
>    a new nsproxy/containers object or optimize storage by searching
>    for one which matches the task's new requirements?

I think the latter.

>
>                 - If we don't support hierarchy in res controllers today
>                   but were to add that support later, then
>                   user-interface shouldn't change. That's why
>                   designining -atleast- the user interface to support
>                   hierarchy may make sense

Right - having support for a hierarchy in the API doesn't mean that
individual controllers have to support being in a hierarchy.

Paul
