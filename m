Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYKST5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYKST5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYKST5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:57:09 -0500
Received: from smtp-out.google.com ([216.239.45.13]:1071 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYKST5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:57:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=M/N6PfoWJcqb4/56Ar41LeOjvYFogiqNzVqyg9Ly0N0xk02iU+lgEnp8vrfeeY8ug
	beJ5SnPV8cPAoIe4hKgVg==
Date: Wed, 19 Nov 2008 11:56:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: print triggering task's cpuset and mems allowed
In-Reply-To: <492369A4.3060104@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0811191156450.20995@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810241704380.15988@chino.kir.corp.google.com> <alpine.DEB.1.10.0810241714290.16902@chino.kir.corp.google.com> <20081027174136.c97687c7.akpm@linux-foundation.org> <alpine.DEB.1.10.0810280222090.31219@chino.kir.corp.google.com>
 <492369A4.3060104@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008, Li Zefan wrote:

> But none of the callers of this function holds task_lock nor rcu_read_lock,
> they hold tasklist_lock. Have you confirmed this is ok? It seems racy that
> the task may be moved to another cgroup and the original cgroup gets removed.
> 

It needs task_lock(current).
