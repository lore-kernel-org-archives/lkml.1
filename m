Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbZFEJdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbZFEJdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZFEJc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:32:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12010 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbZFEJcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:32:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Ox0D8xd79oh96yb0XQpyrytdV0eGYanU7lCPAsK0ADzceJQCXpG8dqssTzdMj+TeI
	yAoWuGUFIyOyWlIHPeM0g==
MIME-Version: 1.0
In-Reply-To: <20090605092733.GA27486@in.ibm.com>
References: <20090604053649.GA3701@in.ibm.com>
	 <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
	 <20090605092733.GA27486@in.ibm.com>
Date: Fri, 5 Jun 2009 02:32:51 -0700
Message-ID: <6599ad830906050232n11aa30d8xfcda0a279a482f32@mail.gmail.com>
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

On Fri, Jun 5, 2009 at 2:27 AM, Bharata B Rao<bharata@linux.vnet.ibm.com> wrote:
>>
>> Suppose 10 cgroups each want 10% of the machine's CPU. We can just
>> give each cgroup an equal share, and they're guaranteed 10% if they
>> try to use it; if they don't use it, other cgroups can get access to
>> the idle cycles.
>
> Now if 11th group with same shares comes in, then each group will now
> get 9% of CPU and that 10% guarantee breaks.

So you're trying to guarantee 11 cgroups that they can each get 10% of
the CPU? That's called over-committing, and while there's nothing
wrong with doing that if you're confident that they'll not al need
their 10% at the same time, there's no way to *guarantee* them all
10%. You can guarantee them all 9% and hope the extra 1% is spare for
those that need it (over-committing), or you can guarantee 10 of them
10% and give the last one 0 shares.

How would you propose to guarantee 11 cgroups each 10% of the CPU
using hard limits?

Paul
