Return-Path: <linux-kernel-owner+w=401wt.eu-S932613AbZJ1H10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbZJ1H10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbZJ1H1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:27:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46574 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbZJ1H1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:27:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Oct 2009 16:24:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: make memcg's file mapped consistent with global
 VM
Message-Id: <20091028162458.45865281.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091028071854.GL16378@balbir.in.ibm.com>
References: <20091028121619.c094e9c0.kamezawa.hiroyu@jp.fujitsu.com>
	<20091028071854.GL16378@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009 12:48:54 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-10-28 12:16:19]:
> 
> > Based on mmotm-Oct13 + some patches in -mm queue.
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > memcg-cleanup-file-mapped-consistent-with-globarl-vm-stat.patch
> > 
> > In global VM, FILE_MAPPED is used but memcg uses MAPPED_FILE.
> > This makes grep difficult. Replace memcg's MAPPED_FILE with FILE_MAPPED
> > 
> > And in global VM, mapped shared memory is accounted into FILE_MAPPED.
> > But memcg doesn't. fix it.
> 
> I wanted to explicitly avoid this since I wanted to do an iterative
> correct accounting of shared memory. The renaming is fine with me
> since we don't break ABI in user space.
> 
To do that, FILE_MAPPED is not correct.
Because MAPPED includes shmem in global VM, no valid reason to do different
style of counting.

For shmem, we have a charge type as MEM_CGROUP_CHARGE_TYPE_SHMEM and 
we can set "PCG_SHMEM" flag onto page_cgroup or some.
Then, we can count it in explicit way. 

Thanks,
-Kame

