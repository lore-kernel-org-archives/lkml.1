Return-Path: <linux-kernel-owner+w=401wt.eu-S1760343AbYBEVEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760343AbYBEVEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbYBEVES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:04:18 -0500
Received: from smtp-out.google.com ([216.239.33.17]:58131 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbYBEVER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:04:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=d2Q7bIOBgJsYM76kzA5MNow0F29RcYnTvi4IkwspY2R40bafVur67AsC0V3Iq78pV
	LePjgQhJtX6ILqVNkdBcQ==
Date: Tue, 5 Feb 2008 13:03:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee.Schermerhorn@hp.com, kosaki.motohiro@jp.fujitsu.com,
       andi@firstfloor.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, clameter@sgi.com, mel@csn.ul.ie
Subject: Re: [2.6.24-rc8-mm1][regression?] numactl --interleave=all doesn't
 works on memoryless node.
In-Reply-To: <20080205145141.ae658c12.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802051259090.26206@chino.kir.corp.google.com>
References: <20080202165054.F491.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080202090914.GA27723@one.firstfloor.org> <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1202149243.5028.61.camel@localhost> <20080205041755.3411b5cc.pj@sgi.com>
 <alpine.DEB.0.9999.0802051146300.5854@chino.kir.corp.google.com> <20080205145141.ae658c12.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Paul Jackson wrote:

> David wrote:
> > The more alarming result of these remaps is in the MPOL_BIND case, as 
> > we've talked about before.  The language in set_mempolicy(2):
> 
> You're diving into the middle of a rather involved discussion
> we had on the other various patches proposed to extend the
> interaction of mempolicy's with cpusets and hotplug.
> 

I've simply identified that MPOL_BIND mempolicy interactions with a task's 
changing mems_allowed as a result of a cpuset move or mems change is also 
an issue that can be addressed at the same time as the interleave problem.  

And it can be done with the addition of a single MPOL_F_* flag.

> I choose not to hijack this current thread with my rebuttal,
> which you've seen before, of your points here.
> 

The issues of mempolicies working over memoryless nodes and supporting 
changing cpusets are very closely related and can be addressed in the same 
way.  It would be disappointing to see a lot of work done to fix the 
memoryless node issue or the changing cpuset mems issue and then realize 
both could have been fixed quite simply with a relatively small set of 
changes.

		David
