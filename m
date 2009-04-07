Return-Path: <linux-kernel-owner+w=401wt.eu-S1761855AbZDGWDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761855AbZDGWDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbZDGWC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:02:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22687 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZDGWC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:02:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=NI2eGYQR4TKMz9jLyF25On335bK9Ffj+IAO5n+oEIdvUjOUIbSvG1Ste1ebxG/xFA
	UIVVxErlxLBOLNoE7PZhQ==
Date: Tue, 7 Apr 2009 15:01:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
In-Reply-To: <49DBB929.4080205@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.0904071456130.32000@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com> <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com> <49DBAF7E.30704@cs.helsinki.fi>
 <alpine.DEB.2.00.0904071302430.32321@chino.kir.corp.google.com> <49DBB373.5050800@cs.helsinki.fi> <alpine.DEB.2.00.0904071316460.21748@chino.kir.corp.google.com> <49DBB929.4080205@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Pekka Enberg wrote:

> Yeah, something more dynamic makes sense. But we probably need to do
> ilog2(nr_cpu_ids) or something; otherwise we will have very long partial lists
> on big iron machines (think 4096 cpus here).
> 

The suggestion was to replace MAX_PARTIAL with nr_cpu_ids, not as the 
default value for n->min_partial, which is ilog2(size).  To exceed the 
current value of MAX_PARTIAL, which is 10, size would need to be 2K or 
greater.

I agree that the default n->min_partial would be better represented in 
terms of cpus than object size.  ilog2(nr_cpu_ids) certainly seems 
appropriate and free partial slabs can always be reclaimed by utilizing 
/sys/kernel/slab/cache/shrink.

The 4096 cpu example is certainly realistic, but probably not UMA.
