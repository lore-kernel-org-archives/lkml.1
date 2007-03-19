Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbXCSU7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbXCSU7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbXCSU7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:59:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:52640 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbXCSU7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:59:54 -0400
From: Andi Kleen <ak@suse.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops callsites to make them patchable
Date: Mon, 19 Mar 2007 21:59:42 +0100
User-Agent: KMail/1.9.5
Cc: virtualization@lists.linux-foundation.org, jbeulich@novell.com,
       jeremy@goop.org, xen-devel@lists.xensource.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, anthony@codemonkey.ws,
       akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu
References: <20070318193030.GB71548@muc.de> <200703191157.29780.ak@suse.de> <20070319.120854.30182994.davem@davemloft.net>
In-Reply-To: <20070319.120854.30182994.davem@davemloft.net>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703192159.42396.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It's inability to handle sequences like the above sounds to me like
> a very good argument to _not_ merge the unwinder back into the tree.

The unwinder can handle it fine, it is just that gcc right now cannot
be taught to generate correct unwind tables for it. If paravirt ops
is widely used i guess it would be possible to find some workaround
for that though.
 
There is one case it truly cannot handle (it would be possible by switching 
to dwarf3), but that was relatively easily eliminated and wasn't a problem
imho.

> To me, that unwinder is nothing but trouble, it severly limits what
> cases you can use special calling conventions via inline asm (and we
> have done that on several occaisions) and even ignoring that the
> unwinder only works half the time.

Initially we had some bugs that accounted for near all failures, but they 
were all fixed in the latest version.
 
> Please don't subject us to another couple months of hair-pulling only
> to have Linus yank the thing out again, there are certainly more
> useful things to spend time on :-)

I think better backtraces are a good use of my time. Sorry if you
disagree on that.

-Andi
