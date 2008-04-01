Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYDAGYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYDAGYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 02:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYDAGY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 02:24:29 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:59509 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751516AbYDAGY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 02:24:28 -0400
To: menage@google.com
Cc: balbir@linux.vnet.ibm.com, xemul@openvz.org, hugh@veritas.com,
       skumar@linux.vnet.ibm.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       rientjes@google.com, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v3)
In-Reply-To: Your message of "Mon, 31 Mar 2008 23:06:12 -0700"
	<6599ad830803312306l59fabaa0o2f62feb0d59b2ce3@mail.gmail.com>
References: <6599ad830803312306l59fabaa0o2f62feb0d59b2ce3@mail.gmail.com>
X-Mailer: Cue version 0.8 (080303-0742/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080401062427.A3E785A05@siro.lan>
Date: Tue,  1 Apr 2008 15:24:27 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Mar 31, 2008 at 11:03 PM, YAMAMOTO Takashi
> <yamamoto@valinux.co.jp> wrote:
> >
> >  changing mm->owner without notifying controllers makes it difficult to use.
> >  can you provide a notification mechanism?
> >
> 
> Yes, I think that call will need to be in the task_lock() critical
> section in which we update mm->owner.
> 
> Right now I think the only user that needs to be notified at that
> point is Balbir's virtual address limits controller.
> 
> Paul

i have some code for which i might want to use mm->owner.
it does somewhat complicated things like acquiring mm_sem and
traversing ptes in its ->attach hook.  (if you want to read the code, search
"Subject: [RFC][PATCH] another swap controller for cgroup" in ML archive.)

probably i don't need to use mm->owner, but it's better if mm->owner can
handle more cases anyway.

YAMAMOTO Takashi
