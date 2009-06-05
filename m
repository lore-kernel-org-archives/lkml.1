Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZFEJss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZFEJss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZFEJsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:48:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3850 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZFEJsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:48:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=HQmi0wgMGm1G4dykdH8kilr0I8NEwmfVLr29myB5+beWFiVhz1YO7x1KiGl0XUqDe
	gfoWh1FpHYz4BkfcdKzAQ==
MIME-Version: 1.0
In-Reply-To: <20090605093625.GI11755@balbir.in.ibm.com>
References: <20090604053649.GA3701@in.ibm.com>
	 <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
	 <20090605093625.GI11755@balbir.in.ibm.com>
Date: Fri, 5 Jun 2009 02:48:36 -0700
Message-ID: <6599ad830906050248m2c569e5bx44fb3bbddf46f8b1@mail.gmail.com>
Subject: Re: [RFC] CPU hard limits
From: Paul Menage <menage@google.com>
To: balbir@linux.vnet.ibm.com
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
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

On Fri, Jun 5, 2009 at 2:36 AM, Balbir Singh<balbir@linux.vnet.ibm.com> wrote:
>
> The important scenario I have is adding and removing groups.
>
> Consider 10 cgroups with shares of 10 each, what if 5 new are created
> with the same shares? We now start getting 100/15, even though we did
> not change our shares.

Are you assuming that arbitrary users can create new cgroups whenever
they like, with whatever shares they like? In that situation, how
would you use hard limits to provide guarantees? Presumably if the
user could create a cgroup with an arbitrary share, they could create
one with an arbitrary hard limit too.

Can you explain a bit more about how you're envisaging cgroups being
created, and how their shares and hard limits would get set? I was
working on the assumption that (for any sub-tree of the CFS hierarchy)
there's a single managing entity that gets to decide the shares given
to the cgroups within that tree. That managing entity would be
responsible for ensuring that the shares given out allowed guarantees
to be met (or alternatively, that the probability of violating those
guarantees based on the shares given out was within some tolerance
threshold).

Paul
