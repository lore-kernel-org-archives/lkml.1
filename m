Return-Path: <linux-kernel-owner+w=401wt.eu-S1750890AbZLOFDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750890AbZLOFDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbZLOFDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:03:13 -0500
Received: from smtp-out.google.com ([216.239.33.17]:25726 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZLOFDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:03:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=xmPghrEkS7ZYuVHAisLCYE/aQNYawqDODtmqWQewuPhh/NSbAEFwomjrmGVGTOj35
	R7ojtR+jIi1XXnXqTL/HA==
Date: Mon, 14 Dec 2009 21:03:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask
 v4.2
In-Reply-To: <20091215134319.CDD3.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0912142100240.436@chino.kir.corp.google.com>
References: <20091215103202.eacfd64e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0912142025090.29243@chino.kir.corp.google.com> <20091215134319.CDD3.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009, KOSAKI Motohiro wrote:

> To compare vsz is only meaningful when the same program are compared.
> But oom killer don't. To compare vsz between another program DONT detect
> any memory leak.
> 

You're losing the ability to detect that memory leak because you'd be 
using a baseline that userspace cannot possibly know at the time of oom.  
You cannot possibly insist that users understand the amount of resident 
memory for all applications when tuning the heuristic adjuster from 
userspace.

In other words, how do you plan on userspace being able to identify tasks 
that are memory leakers if you change the baseline to rss?  Unless you 
have an answer to this question, you're not admitting the problem that 
the oom killer is primarily designed to address.
