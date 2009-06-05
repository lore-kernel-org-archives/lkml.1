Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZFEIxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZFEIxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZFEIxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:53:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:60377 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZFEIxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:53:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=J/vBWJYr2RRk/64vgfyWMGxn+UpMUa+k11gvHscYjU4fnPS3hfl0kHYXClzY2HeMd
	Qoig7U7gIi2vDKZ8EMSnw==
MIME-Version: 1.0
In-Reply-To: <20090604053649.GA3701@in.ibm.com>
References: <20090604053649.GA3701@in.ibm.com>
Date: Fri, 5 Jun 2009 01:53:15 -0700
Message-ID: <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
Subject: Re: [RFC] CPU hard limits
From: Paul Menage <menage@google.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 10:36 PM, Bharata B
Rao<bharata@linux.vnet.ibm.com> wrote:
> - Hard limits can be used to provide guarantees.
>

This claim (and the subsequent long thread it generated on how limits
can provide guarantees) confused me a bit.

Why do we need limits to provide guarantees when we can already
provide guarantees via shares?

Suppose 10 cgroups each want 10% of the machine's CPU. We can just
give each cgroup an equal share, and they're guaranteed 10% if they
try to use it; if they don't use it, other cgroups can get access to
the idle cycles.

Suppose cgroup A wants a guarantee of 50% and two others, B and C,
want guarantees of 15% each; give A 50 shares and B and C 15 shares
each. In this case, if they all run flat out they'll get 62%/19%/19%,
which is within their SLA.

That's not to say that hard limits can't be useful in their own right
- e.g. for providing reproducible loadtesting conditions by
controlling how much CPU a service can use during the load test. But I
don't see why using them to implement guarantees is either necessary
or desirable.

(Unless I'm missing some crucial point ...)

Paul
