Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbZJaTvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbZJaTvY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 15:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933207AbZJaTvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 15:51:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5053 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202AbZJaTvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 15:51:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=e3vwMXkguTBJx6oUIjD8D99zimxh8OfHRrd/jIikgbboAyYpMw3kSEZIXZAulPpY+
	12dQcGykxdSWKc/5OO54A==
Date: Sat, 31 Oct 2009 12:51:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pavel Machek <pavel@ucw.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       stable@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 2/3] page allocator: Do not allow interrupts to use
 ALLOC_HARDER
In-Reply-To: <20091031184054.GB1475@ucw.cz>
Message-ID: <alpine.DEB.2.00.0910311248490.13829@chino.kir.corp.google.com>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <1256650833-15516-3-git-send-email-mel@csn.ul.ie> <20091027130924.fa903f5a.akpm@linux-foundation.org> <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com>
 <20091031184054.GB1475@ucw.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009, Pavel Machek wrote:

> > Giving rt tasks access to memory reserves is necessary to reduce latency, 
> > the privilege does not apply to interrupts that subsequently get run on 
> > the same cpu.
> 
> If rt task needs to allocate memory like that, then its broken,
> anyway...
> 

Um, no, it's a matter of the kernel implementation.  We allow such tasks 
to allocate deeper into reserves to avoid the page allocator from 
incurring a significant penalty when direct reclaim is required.  
Background reclaim has already commenced at this point in the slowpath.
