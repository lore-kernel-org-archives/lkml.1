Return-Path: <linux-kernel-owner+w=401wt.eu-S932177AbZIBGDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbZIBGDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 02:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZIBGDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 02:03:34 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56448 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbZIBGDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 02:03:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=WuFVPBkZ0BOvzRjQJwx8aAsMhnI2jQHoIRqXD42VriBSQpG4FBzFMfOC22d9ALqfz
	BWo1HBpoC5e67nlmZXlMw==
Date: Tue, 1 Sep 2009 23:03:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Ankita Garg <ankita@in.ibm.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix fake numa on ppc
In-Reply-To: <1251870823.14675.420.camel@pasglop>
Message-ID: <alpine.DEB.1.00.0909012259050.26930@chino.kir.corp.google.com>
References: <20090901050316.GA4076@in.ibm.com> <20090901055753.GB5563@balbir.in.ibm.com> <20090901092407.GC4076@in.ibm.com> <20090901142729.GA5022@balbir.in.ibm.com> <20090902053653.GA3806@in.ibm.com> <1251870823.14675.420.camel@pasglop>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009, Benjamin Herrenschmidt wrote:

> Since I'm pretty sure there could be CPU less nodes just like there
> could be memory-less nodes, it would be good if fake numa could
> simulate them too :-)
> 

You don't want to simulate cpu less nodes since they do have affinity to 
ranges of memory, you want to map each fake node to a cpumask including 
all cpus with affinity to its memory, map each cpu to one fake node (with 
memory) that it has physical affinity to, and then give all fake nodes 
local NUMA distance to those on the same physical node.  Memoryless nodes 
take care of themselves since they rely purely on node_distance(), so the 
index into the slit for all fake nodes to those without memory will be the 
same.
