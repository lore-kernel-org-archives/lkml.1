Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbYB0HU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYB0HU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYB0HUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:20:48 -0500
Received: from smtp-out.google.com ([216.239.45.13]:42230 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbYB0HUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:20:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=iHIEDsHcyZwTY8QRO7uEgxAT70rtiT6RzcwTwh5tsFj0/Df1fO9sS4SVPHyyeDFVi
	usEdWJLHUtoMBb2zMF/LA==
Date: Tue, 26 Feb 2008 23:19:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
In-Reply-To: <20080227160746.425E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.00.0802262315030.11433@chino.kir.corp.google.com>
References: <47C4F9C0.5010607@linux.vnet.ibm.com> <alpine.DEB.1.00.0802262201390.1613@chino.kir.corp.google.com> <20080227160746.425E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, KOSAKI Motohiro wrote:

> > Adding yet another sysctl for this functionality seems unnecessary, unless 
> > it is attempting to address other VM problems where page reclaim needs to 
> > be throttled when it is being stressed.  Those issues need to be addressed 
> > directly, in my opinion, instead of attempting to workaround it by 
> > limiting the number of concurrent reclaim threads.
> 
> hm,
> 
> could you post another patch?
> I hope avoid implementless discussion.
> and I hope compare by benchmark result.
> 

My suggestion is merely to make the number of concurrent page reclaim 
threads be a function of how many online cpus there are.  Threads can 
easily be added or removed for cpu hotplug events by callback functions.

That's different than allowing users to change the number of threads with 
yet another sysctl.  Unless there are situations that can be presented 
where tuning the number of threads is advantageous to reduce lock 
contention, for example, and not simply working around other VM problems, 
then I see no point for an additional sysctl.

So my suggestion is to implement this in terms of 
CONFIG_NUM_RECLAIM_THREADS_PER_CPU and add callback functions for cpu 
hotplug events that add or remove this number of threads.

		David
