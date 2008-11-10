Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbYKJU1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbYKJU1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 15:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYKJU1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 15:27:07 -0500
Received: from smtp-out.google.com ([216.239.33.17]:1739 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYKJU1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 15:27:06 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=KKy60vrT4/HQJ1ZQJFICzMf9mlVohiJL8oYgqimLnRoMM1xmpM3ICcYAqCrjL6DRT
	KYeoL8kY/fbym9kXi0C9Q==
Date: Mon, 10 Nov 2008 12:26:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: update top cpuset's mems after adding a node
In-Reply-To: <491828DE.9010505@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0811101222470.1219@chino.kir.corp.google.com>
References: <4917D7B4.4000605@cn.fujitsu.com> <20081110155231.F82E.E1E9C6FF@jp.fujitsu.com> <491828DE.9010505@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2008, Miao Xie wrote:

> on 2008-11-10 14:56 Yasunori Goto wrote:
> > Did you test this patch?  Was it OK?
> 
> I did it on IA64 just now. Updating top cpuset's mems is fine.
> But I forgot to update the mems_allowed of every task in top cpuset group.
> It is difficult to fix it, because I don't know whether updating a memory-bound
> task's mem_allowed is good or not.
> 

There's a fix pending in the mmotm tree that calls 
cpuset_update_task_memory_state() in the slow path of the page allocator, 
so if one of these tasks fails to allocate memory, its cached mems_allowed 
nodemask will be updated to include the new node(s).

The patch is available at 
http://userweb.kernel.org/~akpm/mmotm/broken-out/cpusets-update-mems-allowed-in-page-allocator.patch
