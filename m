Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZEKAY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZEKAY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 20:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZEKAYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 20:24:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:47581 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZEKAYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 20:24:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=emYGeCz0L2FAzBJhdqm3dOdIVg92MPAembOCJmoIkVMI3nYAbqX4KIn97aMIlScY1
	yFIDfYQ+irbUraGHuAziQ==
Date: Sun, 10 May 2009 17:24:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hjonnevag <arve@android.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <20090511085750.B9AC.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905101719040.31823@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101502050.18804@chino.kir.corp.google.com> <20090511085750.B9AC.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, KOSAKI Motohiro wrote:

> > The oom killer must be invoked regardless of the order if the allocation
> > is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> > free some memory.
> 
> This is intensional behavior. plus you change very widely caller bahavior.
> if you don't have good test program, I nak this.
> 

What exactly are you objecting to?  You don't want the oom killer called 
for a __GFP_NOFAIL allocation above PAGE_ALLOC_COSTLY_ORDER that could not 
reclaim any memory and would prefer that it loop endlessly in the page 
allocator?  What's the purpose of that if the oom killer could free a very 
large memory hogging task?
