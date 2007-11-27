Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbXK0JCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbXK0JCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXK0JCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:02:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:59487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbXK0JC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:02:29 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Tom Tucker <tom@opengridcomputing.com>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Date: Tue, 27 Nov 2007 10:02:22 +0100
User-Agent: KMail/1.9.6
Cc: Rusty Russell <rusty@rustcorp.com.au>, Roland Dreier <rdreier@cisco.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <20071122343.446909000@suse.de> <200711271549.37670.rusty@rustcorp.com.au> <1196141742.9876.49.camel@trinity.ogc.int>
In-Reply-To: <1196141742.9876.49.camel@trinity.ogc.int>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271002.22958.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Perhaps you've got lots of patches were people are using internal APIs they 
> > shouldn't?
> > 
> 
> Maybe the issue is "who can tell" since what is external and what is
> internal is not explicitly defined?

Exactly.  Or rather it is not defined on the module level. We got 
"static" of course, but I think we should have a similar mechanism
on a module level.


> Explicitly documenting what comprises the kernel API (external,
> supported) 

It would not be fully supported either -- can still change etc. --
but there is a reasonable expectation that those external
APIs will change less often than internal interfaces.

> - forcing developers to identify their exports as part of the
> implementation or as part of the kernel API

That is EXPORT_SYMBOL already. The trouble is just that it covers
too much. My patchkit is trying to limit it again for a specific
use case -- exporting an "internal" interface to another module.
Or rather a set of modules. 

Standard example is TCP: TCP exports nearly everything and the
single user is the TCP code in ipv6.ko. Instead those symbols should
be limited to be only accessable to ipv6.ko. 

The reason I went with the more generic namespace mechanism
instead of EXPORT_SYMBOL_TO() is that ipv6 is ever split up
it would still work. 

Also using namespaces doesn't have any more overhead than
EXPORT_SYMBOL_TO() and the complexity is about the same
(not very much anyways -- just look at the patches) 

> - making it easier for reviewers to identify when developers are adding
> to the kernel API and thereby focusing the appropriate level of review
> to the new function

That is another reason.
 
-ANdi
