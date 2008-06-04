Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbYFDI7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbYFDI7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYFDI7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:59:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21635 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYFDI7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:59:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=nU5JRjCMAtp94es1Mt1v1P+OiXzpzt2VwFTj0G3/sMVeaMsuo/1NQ0OLT45TY28rd
	bIFJD0Bm06lU7AFb4HXaA==
Message-ID: <6599ad830806040159o648392a1l3dbd84d9c765a847@mail.gmail.com>
Date: Wed, 4 Jun 2008 01:59:32 -0700
From: "Paul Menage" <menage@google.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/2] memcg: hierarchy support (v3)
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
In-Reply-To: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kame,

I like the idea of keeping the kernel simple, and moving more of the
intelligence to userspace.

It may need the kernel to expose a bit more in the way of VM details,
such as memory pressure, OOM notifications, etc, but as long as
userspace can respond quickly to memory imbalance, it should work
fine. We're doing something a bit similar using cpusets and fake NUMA
at Google - the principle of juggling memory between cpusets is the
same, but the granularity is much worse :-)

On Tue, Jun 3, 2008 at 9:58 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>  - supported hierarchy_model parameter.
>   Now, no_hierarchy and hardwall_hierarchy is implemented.

Should we try to support hierarchy and non-hierarchy cgroups in the
same tree? Maybe we should just enforce the restrictions that:

- the hierarchy mode can't be changed on a cgroup if you have children
or any non-zero usage/limit
- a cgroup inherits its parent's hierarchy mode.


>  - parent overcommits all children

I'm not sure that "overcommits" is the right word here - specifically,
the model ensures that a parent can't overcommit its children beyond
its limit.

Paul
