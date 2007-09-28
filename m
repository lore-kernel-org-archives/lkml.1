Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbXI1SiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbXI1SiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbXI1SiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:38:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55853 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752172AbXI1SiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:38:15 -0400
Date: Fri, 28 Sep 2007 11:38:10 -0700
From: Paul Jackson <pj@sgi.com>
To: mel@skynet.ie (Mel Gorman)
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com
Subject: Re: [PATCH 5/6] Filter based on a nodemask as well as a gfp_mask
Message-Id: <20070928113810.9a5cbaf2.pj@sgi.com>
In-Reply-To: <20070928182825.GA9779@skynet.ie>
References: <20070928142326.16783.98817.sendpatchset@skynet.skynet.ie>
	<20070928142506.16783.99266.sendpatchset@skynet.skynet.ie>
	<1190993823.5513.10.camel@localhost>
	<20070928182825.GA9779@skynet.ie>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel replied to Lee:
> > > +	return nodes_intersect(nodemask, current->mems_allowed);
> >                  ^^^^^^^^^^^^^^^ -- should be nodes_intersects, I think.
> 
> Crap, you're right, I missed the warning about implicit declarations. I
> apologise. This is the corrected version

I found myself making that same error, saying 'nodes_intersect' instead
of 'nodes_intersects' the other day.  And I might be the one who invented
that name ;).

This would probably be too noisey and too little gain to do on the
Linux kernel, but if this was just a little private project of my own,
I'd be running a script over the whole thing, modifying all 30 or so
instances of bitmap_intersects, cpus_intersects and nodes_intersects so
as to remove the final 's' character.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
