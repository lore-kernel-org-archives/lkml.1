Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab0BDWO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 17:14:59 -0500
Received: from smtp-out.google.com ([216.239.33.17]:51635 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab0BDWO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 17:14:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=XrmTtOnmXCLJYf3dfulCG2wI3LdNVEoHqCDcw9mDF3APxuWDm8d77L/u+K9wJVOO9
	y2dhGvKwEFJJfgIsj8xbA==
Date: Thu, 4 Feb 2010 14:14:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rik van Riel <riel@redhat.com>
cc: Lubos Lunak <l.lunak@suse.cz>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
In-Reply-To: <4B6B4500.3010603@redhat.com>
Message-ID: <alpine.DEB.2.00.1002041410300.16391@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <20100203170127.GH19641@balbir.in.ibm.com> <alpine.DEB.2.00.1002031021190.14088@chino.kir.corp.google.com> <201002032355.01260.l.lunak@suse.cz> <alpine.DEB.2.00.1002031600490.27918@chino.kir.corp.google.com>
 <4B6A1241.60009@redhat.com> <alpine.DEB.2.00.1002041339220.6071@chino.kir.corp.google.com> <4B6B4500.3010603@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Rik van Riel wrote:

> > Keep in mind that we're in the oom killer here, though.  So we're out of
> > memory and we need to kill something; should Apache, Oracle, and postgres
> > not be penalized for their cost of running by factoring in something like
> > this?
> 
> No, they should not.
> 
> The goal of the OOM killer is to kill some process, so the
> system can continue running and automatically become available
> again for whatever workload the system was running.
> 
> Killing the parent process of one of the system daemons does
> not achieve that goal, because you now caused a service to no
> longer be available.
> 

The system daemon wouldn't be killed, though.  You're right that this 
heuristic would prefer the system daemon slightly more as a result of the 
forkbomb penalty, but the oom killer always attempts to sacrifice a child 
with a seperate mm before killing the selected task.  Since the forkbomb 
heuristic only adds up those children with seperate mms, we're guaranteed 
to not kill the daemon itself.
