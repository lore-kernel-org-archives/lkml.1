Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZFYUgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZFYUgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZFYUgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:36:37 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34697 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbZFYUgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:36:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=pG5mKdO+DgY6HKDhLqLi+dZFsRpSYtTdZ4SO32BchPkLz/mc1HQHNHXvauRurjs6e
	IN/ML1mKu7yVvfqLsJ8FA==
Date: Thu, 25 Jun 2009 13:36:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       penberg@cs.helsinki.fi, arjan@infradead.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <alpine.LFD.2.01.0906251317570.3605@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0906251332060.3086@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain> <20090624130121.99321cca.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
 <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.LFD.2.01.0906251259430.3605@localhost.localdomain> <alpine.LFD.2.01.0906251317570.3605@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Linus Torvalds wrote:

> It might make more sense to make a __GFP_WAIT allocation set the 
> ALLOC_HARDER bit _if_ it repeats. 

This would make sense, but only for !__GFP_FS, since otherwise the oom 
killer will free some memory on an allowed node when reclaim fails and we 
don't otherwise want to deplete memory reserves.
