Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbYEVEVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbYEVEVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYEVEVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:21:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754AbYEVEVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:21:30 -0400
Date: Wed, 21 May 2008 21:19:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm][PATCH 3/4] cgroup mm owner callback changes to add task
 info (v5)
Message-Id: <20080521211958.ca4f733c.akpm@linux-foundation.org>
In-Reply-To: <20080521152959.15001.14495.sendpatchset@localhost.localdomain>
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>
	<20080521152959.15001.14495.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 20:59:59 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> This patch adds an additional field to the mm_owner callbacks. This field
> is required to get to the mm that changed. Hold mmap_sem in write mode
> before calling the mm_owner_changed callback
>
> ...
>
> + * The callbacks are invoked with mmap_sem held in read mode.

Is that true?

> +	down_write(&mm->mmap_sem);
> ...
>  	cgroup_mm_owner_callbacks(mm->owner, c);

Looks like write-mode to me?
