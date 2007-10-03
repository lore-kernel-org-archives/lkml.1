Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbXJCSZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbXJCSZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbXJCSZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:25:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:27089 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbXJCSZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:25:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=YSUcZdfZ9ytsNV3oUehQxyLCdYyohWSAv5eoqMkXFxmYfmsrD7s0wuq40o9jlJ73y
	BUGjgUdbi/BM6rxVtAbAQ==
Message-ID: <6599ad830710031125v68aac64aic4ad7e5114fa8ac@mail.gmail.com>
Date: Wed, 3 Oct 2007 11:25:21 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] task containersv11 add tasks file interface fix for cpusets
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       serue@us.ibm.com, clg@fr.ibm.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, rientjes@google.com, svaidy@linux.vnet.ibm.com,
       xemul@openvz.org, containers@lists.osdl.org, balbir@linux.vnet.ibm.com
In-Reply-To: <6599ad830710031110r1a74eafej56f20cc33e72ac81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>
	 <6599ad830710030851jb44f00ft9634f9381218b6e9@mail.gmail.com>
	 <20071003105817.7adf6516.pj@sgi.com>
	 <6599ad830710031110r1a74eafej56f20cc33e72ac81@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/07, Paul Menage <menage@google.com> wrote:
>
> What's wrong with, in update_cpumask(), doing a loop across all
> members of the cgroup and updating their cpus_allowed fields?

i.e. something like:

struct cgroup_iter it;
struct task_struct *p;
while ((p = cgroup_iter_next(cs->css.cgroup, &it))) {
	set_cpus_allowed(p, cs->cpus_allowed);
}
cgroup_iter_end(cs->css.cgroup, &it);

Paul
