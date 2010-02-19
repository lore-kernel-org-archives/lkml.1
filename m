Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab0BSJmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 04:42:37 -0500
Received: from smtp-out.google.com ([216.239.44.51]:18903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0BSJmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 04:42:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FSlvJzL9IKtVSc/TMHKvsswBoHWiKrjhNJ3GtG/HwDjTwAoW21J3qmpnZaP+W9uYt
	L0mEMR3fvfx9E6NtDsong==
Date: Fri, 19 Feb 2010 01:42:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Miao Xie <miaox@cn.fujitsu.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time
 (58568d2)
In-Reply-To: <20100219164754.A1C3.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002190137530.6293@chino.kir.corp.google.com>
References: <20100218134921.GF9738@laptop> <20100219164754.A1C3.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Feb 2010, KOSAKI Motohiro wrote:

> Personally, I like just revert at once than bandaid. 58568d2 didn't
> introduce any new feature, then we can revet it without abi breakage.
> 

Revert a commit from more than six months ago when the fix is probably a 
small patch in cpuset_attach()?  I think we can do better than that.

This may not have introduced a new feature, but it was a worthwhile change 
to avoid the old cpuset_update_task_memory_state() hooks in mempolicy, 
page allocator, etc. code that could block on callback_mutex for iterating 
the hierarchy.
