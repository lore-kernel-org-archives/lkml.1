Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbYIRGNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbYIRGNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 02:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYIRGNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 02:13:31 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:40098 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751449AbYIRGNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 02:13:30 -0400
Date: Thu, 18 Sep 2008 15:13:26 +0900 (JST)
Message-Id: <20080918.151326.98179387.taka@valinux.co.jp>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com,
       dave@linux.vnet.ibm.com, nickpiggin@yahoo.com.au, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page (v3)
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080918135023.99cac1d0.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080917184008.92b7fc4c.akpm@linux-foundation.org>
	<20080918.132613.74431429.taka@valinux.co.jp>
	<20080918135023.99cac1d0.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > But I think each memory model type should have its own way of managing
> > its page_cgroup arrays as doing for its struct page arrays.
> > It would be better rather than the sparsemem approach he said.
> > 
> My patch adds an interface. Then...
> FLATMEM support will be very easy.

Yes, that is true, it is really easy.

> I'll ignore DISCONTIGMEM and SPARSEMEM (they will use my 'hash')

What part of this do you think is the problem to implement it in the
straight way for this model?
I think it won't be difficult to implement it since each pgdat can have
its page_cgroup array, which can care about holes in the node as well as
doing it for its struct page array.

> SPARSEMEM_VMEMMAP support will took some amount of time. It will need
> per-arch patches.

Yes, each of ia64, powerpc and x86_64 use this memory model.

We should also care about the regular SPARSEMEM case as you mentioned.

> Thanks,
> -Kame

