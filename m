Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab0BCJlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:41:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:6150 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab0BCJlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:41:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=QXmG9U/aLRybOtdI+AFiQQqgjSeYL51lyLjrEfr5v5sIz1dN8nbShQz0wcGmfcmrL
	clHUDlJWDCTOzDZb5vqhQ==
Date: Wed, 3 Feb 2010 01:40:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Lubos Lunak <l.lunak@suse.cz>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Nick Piggin <npiggin@suse.de>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
In-Reply-To: <20100203164612.D3AC.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002030131330.11389@chino.kir.corp.google.com>
References: <201002012302.37380.l.lunak@suse.cz> <20100203164612.D3AC.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, KOSAKI Motohiro wrote:

> Personally, I think your use case represent to typical desktop and Linux
> have to works fine on typical desktop use-case. /proc/pid/oom_adj never fit
> desktop use-case. In past discussion, I'v agreed with much people. but I haven't
> reach to agree with David Rientjes about this topic.
> 

Which point don't you agree with?  I've agreed that heuristic needs to be 
changed and since Kame has decided to abandon his oom killer work, I said 
that I would find time to develop a solution that would be based on 
consensus.  I don't think that simply replacing the baseline with rss, 
rendering oom_adj practically useless for any other purpose other than 
polarizing priorities, and removing any penalty for tasks that fork an 
egregious amount of tasks is acceptable to all parties, though.

When a desktop system runs a vital task that, at all costs, cannot 
possibly be oom killed such as KDE from the user perspective, is it really 
that outrageous of a request to set it to OOM_DISABLE?  No, it's not.  
There are plenty of open source examples of applications that tune their 
own oom_adj values for that reason; userspace input into the oom killer's 
heuristic will always be an integral part of its function.

I believe that we can reach consensus without losing the existing 
functionality that oom_adj provides, namely defining vital system tasks 
and memory leakers, and without this all or nothing type attitude that 
insists we either go with rss as a baseline because "it doesn't select X 
first in my particular example" or you'll just take your ball and go home.
