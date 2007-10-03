Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbXJCUb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbXJCUb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 16:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXJCUbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 16:31:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:35477 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbXJCUbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 16:31:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=kFiiUg7FJtwTg9jJdNCKm3vXKy5epeGWE4Bmy+ATqvlcCKn+tFflgZg5kBRlgUIeG
	qZD83gfYubBI4pJsmv2uQ==
Message-ID: <6599ad830710031331h15d35e90lc63d845efd2de6f5@mail.gmail.com>
Date: Wed, 3 Oct 2007 13:31:17 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] task containersv11 add tasks file interface fix for cpusets
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       serue@us.ibm.com, clg@fr.ibm.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, rientjes@google.com, svaidy@linux.vnet.ibm.com,
       xemul@openvz.org, containers@lists.osdl.org, balbir@linux.vnet.ibm.com
In-Reply-To: <20071003131632.fed4b848.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>
	 <6599ad830710030851jb44f00ft9634f9381218b6e9@mail.gmail.com>
	 <20071003105817.7adf6516.pj@sgi.com>
	 <6599ad830710031110r1a74eafej56f20cc33e72ac81@mail.gmail.com>
	 <20071003131632.fed4b848.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/07, Paul Jackson <pj@sgi.com> wrote:
>
> So far as I can tell, this patch just removes a minor optimization,

It's not minor for any subsystem that has a non-trivial attach() operation.

>
> Any further suggestions, or embarrassing (;) questions?
>

What was wrong with my suggestion from a couple of emails back? Adding
the following in cpuset_attach():

struct cgroup_iter it;
struct task_struct *p;
while ((p = cgroup_iter_next(cs->css.cgroup, &it))) {
       set_cpus_allowed(p, cs->cpus_allowed);
}
cgroup_iter_end(cs->css.cgroup, &it);

Paul
