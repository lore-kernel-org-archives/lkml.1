Return-Path: <linux-kernel-owner+w=401wt.eu-S965849AbXDBUjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965849AbXDBUjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965847AbXDBUjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:39:40 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46660 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965844AbXDBUjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:39:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=fyk5NEGC7xGNHFoWI4UTgM6OnvAMA4X0LNvGSj1CEInhJCODEdJw4xjB1dabZeBaC
	EbNdtaptCDGDq5Q2PNHhA==
Message-ID: <461169CF.6060806@google.com>
Date: Mon, 02 Apr 2007 13:38:39 -0700
From: Martin Bligh <mbligh@google.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Dave Hansen <hansendc@us.ibm.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 1/4] x86_64: Switch to SPARSE_VIRTUAL
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>  <20070401071029.23757.78021.sendpatchset@schroedinger.engr.sgi.com>  <200704011246.52238.ak@suse.de>  <Pine.LNX.4.64.0704020832320.30394@schroedinger.engr.sgi.com> <1175544797.22373.62.camel@localhost.localdomain> <Pine.LNX.4.64.0704021324480.31842@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704021324480.31842@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 2 Apr 2007, Dave Hansen wrote:
> 
>> I completely agree, it looks like it should be faster.  The code
>> certainly has potential benefits.  But, to add this neato, apparently
>> more performant feature, we unfortunately have to add code.  Adding the
>> code has a cost: code maintenance.  This isn't a runtime cost, but it is
>> a real, honest to goodness tradeoff.
> 
> Its just the opposite. The vmemmap code is so efficient that we can remove 
> lots of other code and gops of these alternate implementations. On x86_64 
> its even superior to FLATMEM since FLATMEM still needs a memory reference 
> for the mem_map area. So if we make SPARSE standard for all 
> configurations then there is no need anymore for FLATMEM DISCONTIG etc 
> etc. Can we not cleanup all this mess? Get rid of all the gazillions 
> of #ifdefs please? This would ease code maintenance significantly. I hate 
> having to constantly navigate my way through all the alternatives.

The original plan when this was first merged was pretty much that -
for sparsemem to replace discontigmem once it was well tested. Seems
to have got stalled halfway through ;-(

Not sure we'll get away with replacing flatmem for all arches, but
we could at least get rid of discontigmem, it seems.

M.
