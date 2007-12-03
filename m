Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbXLCJuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbXLCJuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbXLCJuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:50:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44333 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbXLCJuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:50:24 -0500
Date: Mon, 3 Dec 2007 10:50:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@argo.co.il>
Cc: Andi Kleen <andi@firstfloor.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071203095022.GA28560@one.firstfloor.org>
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca> <53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com> <4751BE0D.3050609@argo.co.il> <p733aukyl8n.fsf@bingen.suse.de> <47539030.10600@argo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47539030.10600@argo.co.il>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Even these (with the exception of the page fault path) are hardly "we 
> care about a single instruction" material suggested above.  Even with a 

With 10Gbit/s ethernet working you start to care about every cycle.
Similar with highend routing or in some latency sensitive network
applications (e.g. in HPC). Another simple noticeable case is Unix
sockets and your X server communication. 

And there are some special cases where block IO is also pretty critical.
A popular one is TPC-* benchmarking, but there are also others and it 
looks likely in the future that this will become more critical
as block devices become faster (e.g. highend SSDs) 

> The real benefits aren't in keeping close to the metal, but in high 
> level optimizations.  Ironically, these are easier when the code is a 
> little more abstracted.  You can add quite a lot of instructions if it 
> allows you not to do some of the I/O at all.

While that's partly true -- cache misses are good for a lot of cycles --
it is not the whole truth and at some point raw code efficiency matters
too.

For example there are some CPUs who are relatively slow at indirect
function calls and there are actually cases where this can be measured.

-Andi

