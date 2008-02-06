Return-Path: <linux-kernel-owner+w=401wt.eu-S1763943AbYBFCHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763943AbYBFCHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763586AbYBFCGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:06:47 -0500
Received: from smtp-out.google.com ([216.239.33.17]:8699 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763546AbYBFCGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:06:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=LrrZHn4oVFI/vHLQapTYhf+SJCJrL7n0xkXSRhOIYly4InQPsA+BvqpGZ6TA6kL8A
	p5hioJMLp4VEbMbpu8y9g==
Date: Tue, 5 Feb 2008 18:05:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Jeff Davis <linux@j-davis.com>, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrea Arcangeli <andrea@qumranet.com>
Subject: Re: [PATCH] badness() dramatically overcounts memory
In-Reply-To: <20080206105041.2717.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.00.0802051802460.18339@chino.kir.corp.google.com>
References: <1202252561.24634.64.camel@dogma.ljc.laika.com> <alpine.DEB.1.00.0802051507460.18347@chino.kir.corp.google.com> <20080206105041.2717.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, KOSAKI Motohiro wrote:

> > Andrea Arcangeli has patches pending which change this to the RSS.  
> > Specifically:
> > 
> > 	http://marc.info/?l=linux-mm&m=119977937126925
> 
> I agreed with you that RSS is better :)
> 
> 
> 
> but..
> on many node numa, per zone rss is more better..
> 

It depends on how your applications are taking advantage of NUMA 
optimizations.  If they're constrained by mempolicies to a subset of nodes 
then the badness scoring isn't even used: the task that triggered the OOM 
condition is the one that is automatically killed.

At this point, I think you're going to need to present an actual case 
study where Andrea's patch isn't sufficient for selecting the appropriate 
task on large NUMA machines.

		David
