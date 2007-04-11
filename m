Return-Path: <linux-kernel-owner+w=401wt.eu-S1751326AbXDKInJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbXDKInJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXDKInJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:43:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43742 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbXDKInI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:43:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=fCFu+lw7beAa4k5eb3HjMa22kKcKy/WSehPq6jIh8Ud4o/4edCdrVk7fJc2hFJn1f
	6y7Xxz45Ue022LtRDi6uQ==
Message-ID: <6599ad830704110142yf00e878n97b4162ebbeee5d@mail.gmail.com>
Date: Wed, 11 Apr 2007 01:42:54 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 3/7] Containers (V8): Add generic multi-subsystem API to containers
Cc: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
In-Reply-To: <20070411050121.GB15786@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070406233221.989528000@menage.corp.google.com>
	 <20070407001324.271959000@menage.corp.google.com>
	 <20070411050121.GB15786@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> [ Sorry abt piece meal reviews, I am sending comments as and when I spot
> something ]

That's no problem.

>
> On Fri, Apr 06, 2007 at 04:32:24PM -0700, menage@google.com wrote:
> > -void container_exit(struct task_struct *tsk)
> > +void container_exit(struct task_struct *tsk, int run_callbacks)
> >  {
>
> [snip]
>
> > +     /* Reassign the task to the init_container_group. */
> >       task_lock(tsk);
>
> [snip]
>
> > +     if (tsk->containers != &init_container_group) {
>
> Is this check needed? If we have the check, then:
>
> > +     task_unlock(tsk);
> > +     if (cg)
> > +             put_container_group(cg);
>
> init_container_group refcount is leaky (fork increments it, but exit
> doesnt). Not a big prob perhaps, but ..would be nice to avoid?
>

Yes, I think you're right - over a long uptime that would just cause
problems ...

Paul
