Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYDAGDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYDAGDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 02:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYDAGDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 02:03:32 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:37041 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751398AbYDAGDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 02:03:31 -0400
To: balbir@linux.vnet.ibm.com
Cc: menage@google.com, xemul@openvz.org, hugh@veritas.com,
       skumar@linux.vnet.ibm.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       rientjes@google.com, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v3)
In-Reply-To: Your message of "Tue, 01 Apr 2008 11:13:24 +0530"
	<20080401054324.829.4517.sendpatchset@localhost.localdomain>
References: <20080401054324.829.4517.sendpatchset@localhost.localdomain>
X-Mailer: Cue version 0.8 (080303-0742/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080401060330.743815A02@siro.lan>
Date: Tue,  1 Apr 2008 15:03:30 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch removes the mem_cgroup member from mm_struct and instead adds
> an owner. This approach was suggested by Paul Menage. The advantage of
> this approach is that, once the mm->owner is known, using the subsystem
> id, the cgroup can be determined. It also allows several control groups
> that are virtually grouped by mm_struct, to exist independent of the memory
> controller i.e., without adding mem_cgroup's for each controller,
> to mm_struct.
> 
> A new config option CONFIG_MM_OWNER is added and the memory resource
> controller selects this config option.
> 
> NOTE: This patch was developed on top of 2.6.25-rc5-mm1 and is applied on top
> of the memory-controller-move-to-own-slab patch (which is already present
> in the Andrew's patchset).
> 
> I am indebted to Paul Menage for the several reviews of this patchset
> and helping me make it lighter and simpler.
> 
> This patch was tested on a powerpc box, by running a task under the memory
> resource controller and moving it across groups at a constant interval.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---

changing mm->owner without notifying controllers makes it difficult to use.
can you provide a notification mechanism?

YAMAMOTO Takashi
