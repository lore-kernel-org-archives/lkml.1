Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZJNHZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZJNHZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZJNHZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:25:58 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41438 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbZJNHZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:25:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MlraK9k8DStb4TJUGl2Io2PbBnXHmPlH7zjIxQhLAuZ6lwZEFhVagl8jFixtKLJ3L
	5f5UMxGVQ1jOMhOfhk96g==
Date: Wed, 14 Oct 2009 00:24:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
In-Reply-To: <20091014065941.GH784@elte.hu>
Message-ID: <alpine.DEB.1.00.0910140014490.26562@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910130004.46388.elendil@planet.nl> <20091013070505.GC31483@elte.hu> <200910131952.01209.elendil@planet.nl> <alpine.LFD.2.01.0910131100180.26777@localhost.localdomain>
 <alpine.DEB.1.00.0910131649280.24112@chino.kir.corp.google.com> <20091014065941.GH784@elte.hu>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Ingo Molnar wrote:

> > I don't think you want to do that because it would require the .config 
> > to be posted on bug reports, for example, to determine the setting of 
> > CONFIG_LOCALVERSION_AUTO before you can interpret the kernel version.  
> > In other words, you wouldn't know that "2.6.32-rc4" is actually 200 
> > commits beyond the actual release unless you also know that the 
> > .config has CONFIG_LOCALVERSION_AUTO="none".
> 
> We've come a full circle ...
> 
> That's the current !CONFIG_LOCALVERSION_AUTO status quo ... That was 
> being asked to be preserved for (unspecified) packaging reasons. So
> your suggestion is to do away with that behavior altogether?
> 

I don't think it's helpful to specify a version as "2.6.32-rc4" when in 
reality it has 200 commits beyond the release and I like the addition of 
`+' for !CONFIG_LOCALVERSION_AUTO if we're not at a tagged commit.  
That's what my two patches do so the only time you could get a 
"2.6.32-rc4" version string is for when it's the equivalent of 
http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.32-rc4.tar.bz2 
(and you would actually get that regardless of whether you're using 
CONFIG_LOCALVERSION_AUTO or not).

There's another possible extension that could be made: we could allow 
LOCALVERSION= as passed to "make" to override the added `+' since it is 
used to identify kernel versions by a string anyway; so make 
LOCALVERSION=-slub_fixes would become v2.6.32-rc4-slub_fixes if 
CONFIG_LOCALVERSION_AUTO were disabled, regardless of what commit we're 
at, and v2.6.32-rc4-slub_fixes-00094-g80f5069 if it were enabled.

Regardless of future improvements, I think my two patches allow the kernel 
version to more accurately describe what is running.  That is predicated 
on my belief that "v2.6.32-rc4", though, should never describe _anything_ 
except the kernel.org v2.6.32-rc4 kernel.
