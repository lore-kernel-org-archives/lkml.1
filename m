Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZCIUNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZCIUNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZCIUNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:13:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61277 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbZCIUNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:13:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MRQA/6yFPdl18Rp/X/dnwTsgllwpAC1OmmXgHlCBq1D0lVu/xvvh9UC4O++iJR97g
	uyw4BBs+84ri6xCXH/vdw==
Date: Mon, 9 Mar 2009 13:13:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <alpine.DEB.1.10.0903091448110.20314@qirst.com>
Message-ID: <alpine.DEB.2.00.0903091307570.27253@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com> <alpine.DEB.1.10.0903091448110.20314@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Christoph Lameter wrote:

> Again these are fastpath modifications.
> 

The nature of the change requires the logic to be placed in the fastpath 
to determine whether a cpu slab's node is allowed by the allocating task's 
cpuset.

You have previously stated that you would prefer that this feature be 
tunable from userspace.  This patch adds the `memory_slab_hardwall' cpuset 
flag which defaults to off.

> Scanning the partial list for matching nodes is an expensive operation.
> 

It depends on how long you scan for a matching node, but again: this 
should be assumed by the user if the option has been enabled.

> Adding RCU into the fast paths is also another big worry.
> 

This could be mitigated by adding a PF_SLAB_HARDWALL flag similiar to 
PF_SPREAD_PAGE and PF_SPREAD_SLAB.  I'd prefer not to add additional 
cpuset-specific task flags, but this would address your concern.
