Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbYHTFsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbYHTFsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 01:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYHTFrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 01:47:39 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:44674 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751304AbYHTFri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 01:47:38 -0400
Date: Wed, 20 Aug 2008 14:47:36 +0900 (JST)
Message-Id: <20080820.144736.16128062.taka@valinux.co.jp>
To: balbir@linux.vnet.ibm.com
Cc: ryov@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@sourceware.org, xemul@openvz.org,
       fernando@oss.ntt.co.jp
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory subsystem into
 two parts
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <48AACF41.5090905@linux.vnet.ibm.com>
References: <48AA4594.1000908@linux.vnet.ibm.com>
	<20080819.214635.70071441.taka@valinux.co.jp>
	<48AACF41.5090905@linux.vnet.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >>>> I'm now writing remove-lock-page-cgroup patches. it works well.
> >>>> please wait for a while...
> >>> I'm looking forward to those patches.
> >>>
> >>> By the way, I'm glad if memory-cgroup has a feature which can make a
> >>> page_cgroup move between cgroups with small overhead. It makes
> >>> bio-cgroup improve the accuracy of tracking down pages.
> >> Page movement can be a very expensive operation and is proportional to the size
> >> of the control group. I think movement should be an optional feature, if we ever
> >> add it.
> > 
> > Yes, we should avoid moving pages as far as it is balanced fairly well
> > between groups.
> > 
> > But I want to move pages between bio-cgoups in case it started charging
> > quite a few I/O requests to a wrong bio-cgroup. I think it will be okay
> > if pages moves between bio-cgroups, but they don't need to move between
> > memory cgroups. I know the latter is really heavy and the effect seems
> > to be so limited.
> 
> I was under the impression that you wanted memory-cgroup to provide the page
> movement feature. That is not on the TODO list for us now.

I think it's practically enough to implement this feature only on
bio-cgroup side and leave the memory controller untouched.
This kind of requests will happen only when making pages dirty.

Of cousrse I'd be happier if you put it on your list to implement
this as a generic feature.

Thanks,
Hirokazu Takahsahi.
