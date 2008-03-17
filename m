Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYCQFXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYCQFXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 01:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYCQFW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 01:22:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49685 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbYCQFW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 01:22:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=IIskH/+/UgK7sjWt1Xeb69Zvt+fr2j9iGmhrowe5QOO1hsQscAoI980FSXovKi8SP
	pTYNfIS9QYlj5t/jl5Anw==
Message-ID: <6599ad830803162222t6c32f5a1qd4d0af4887dfa910@mail.gmail.com>
Date: Mon, 17 Mar 2008 13:22:48 +0800
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][0/3] Virtual address space control for cgroups
Cc: "Li Zefan" <lizf@cn.fujitsu.com>, linux-mm@kvack.org,
       "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp,
       "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47DDFCEA.3030207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080316172942.8812.56051.sendpatchset@localhost.localdomain>
	 <6599ad830803161626q1fcf261bta52933bb5e7a6bdd@mail.gmail.com>
	 <47DDCDA7.4020108@cn.fujitsu.com>
	 <6599ad830803161857r6d01f962vfd0f570e6124ab24@mail.gmail.com>
	 <47DDFCEA.3030207@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 1:08 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>  I understand the per-mm pointer overhead back to the cgroup. I don't understand
>  the part about adding a per-mm pointer back to the "owning" task. We already
>  have task->mm.

Yes, but we don't have mm->owner, which is what I was proposing -
mm->owner would be a pointer typically to the mm's thread group
leader. It would remove the need to have to have pointers for the
various different cgroup subsystems that need to act on an mm rather
than a task_struct, since then you could use
mm->owner->cgroups[subsys_id].

But this is kind of orthogonal to whether virtual address space limits
should be a separate cgroup subsystem.

Paul
