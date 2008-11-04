Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbYKDVLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbYKDVLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYKDVLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:11:23 -0500
Received: from smtp-out.google.com ([216.239.33.17]:32747 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbYKDVLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:11:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=TAsOAcXqoJe6s9Y5nspis7v8PplmndI6+uMbVppAlkqG5XIPBP7XQ+K/02IsmTxoQ
	Wo82+gFzj4y7dMBGiJqoA==
Date: Tue, 4 Nov 2008 13:10:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org,
       npiggin@suse.de, menage@google.com, dfults@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] cpuset writeback throttling
In-Reply-To: <1225831988.7803.1939.camel@twins>
Message-ID: <alpine.DEB.2.00.0811041306510.27392@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>  <20081104124753.fb1dde5a.akpm@linux-foundation.org> <1225831988.7803.1939.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008, Peter Zijlstra wrote:

> I think the main reason is that we have per-node vmstats so the cpuset
> extention is relatively easy. Whereas we do not currently maintain
> vmstats on a cgroup level - although I imagine that could be remedied.
> 

That's correct, the ZVC values from each node assigned to a particular 
cpuset is used to determine the dirty ratios.  We don't currently have the 
infrastructure to do that with any other cgroup.

So extracting this out to a separate cgroup is fine, but it's still only 
applicable to cpusets at this time.  Let me know what the prerequisites 
are for -mm inclusion.
