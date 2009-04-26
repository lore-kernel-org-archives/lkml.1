Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbZDZTzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbZDZTzp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 15:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZDZTzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 15:55:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:9646 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbZDZTzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 15:55:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=UhhJRgltBYGadKZe9Fhgn27GKVczSWG6jZ45iQ1gEs8mTIiqguBoQpojvr9druTDc
	VOcTmAuZFmyZ5KPa9gr7A==
Date: Sun, 26 Apr 2009 12:55:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zeno Davatz <zdavatz@gmail.com>
cc: linux-kernel@vger.kernel.org, Hannes Wyss <hwyss@ywesee.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
In-Reply-To: <40a4ed590904250132o63e715cbvaccf5aac82265cd@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0904261252010.18988@chino.kir.corp.google.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com> <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com> <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com> <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
 <40a4ed590904241216u655300ddvaa4660e11ad2cffc@mail.gmail.com> <alpine.DEB.2.00.0904241224001.28589@chino.kir.corp.google.com> <40a4ed590904250132o63e715cbvaccf5aac82265cd@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009, Zeno Davatz wrote:

> Couldn't you start killing processes at an earlier stage? It seems to
> me that the stage when processes are being killed by oom_killer is a
> bit late in the game, when the machine is anyway very close to the
> freezing point. I mean we had these messages of oom_kill several times
> in our /var/log/kernel/current over a distributed amount of time.
> 

The oom killer serves a very well-defined purpose: to kill a 
memory-hogging task when your system (or cpuset, memory controller) is out 
of memory.  When it kills a task, it also allows access to memory reserves 
that allow it to allocate beyond each allowable zone's min watermark.  
This is intended to allow the task to quickly exit.

There is work being done on a per-cgroup lowmem notifier which would allow 
userspace to poll() on a device file and be notified of low memory 
situations so that it can react on its own (like killing a low priority 
task, expanding a cpuset, increasing a memcontroller limit, etc.)
