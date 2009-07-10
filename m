Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbZGJKDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbZGJKDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbZGJKD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:03:27 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37884 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZGJKD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:03:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=DhDO9xiNy3ntqV24r4PKGEajDjP1ZlJRzQLZoREqZEcKyFJqQfl3cit4USxDjmERh
	JWMPoF8TIyglbSyPdXw0Q==
Date: Fri, 10 Jul 2009 03:03:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, fche@redhat.com, cl@linux-foundation.org
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
In-Reply-To: <1247219506.771.22.camel@penberg-laptop>
Message-ID: <alpine.DEB.2.00.0907100253560.14601@chino.kir.corp.google.com>
References: <1247156020.27671.40.camel@debian-nb> <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com> <20090710084745.GA26752@elte.hu> <1247215920.32044.3.camel@penberg-laptop> <20090710090351.GD14666@wotan.suse.de> <1247217263.771.8.camel@penberg-laptop>
 <20090710092921.GF14666@wotan.suse.de> <1247218826.771.15.camel@penberg-laptop> <alpine.DEB.2.00.0907100243010.14601@chino.kir.corp.google.com> <1247219506.771.22.camel@penberg-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009, Pekka Enberg wrote:

> Hey, I said SLAB is on its way out (yes, it really is). But I didn't say
> we're going to blindly remove it if performs better than the
> alternatives. I don't see any reason why SQLB can't reach the same
> performance as SLAB after on fundamental level, though. Can you?
> 

I'm not really interested in making predictions on which design has the 
greatest potential for pure performance, I'm interested in what is proven 
to work and does the job better than any alternative.  Right now, for 
certain workloads, that's undeniably slab.  So I'd disagree that slab is 
on its way out until another allocator is shown to at least have parity 
with it (at which time I'd become more interested in the cleanliness of 
the code, the debugging support, etc.).

It's my opinion that slab is on its way out when there's no benchmark that 
shows it is superior by any significant amount.  If that happens (and if 
its successor is slub, slqb, or a yet to be implemented allocator), we can 
probably start a discussion on what's in and what's out at that time.
