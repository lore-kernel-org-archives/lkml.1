Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbXKISWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbXKISWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 13:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbXKISW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 13:22:29 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48270 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752594AbXKISW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 13:22:29 -0500
Date: Fri, 9 Nov 2007 10:22:28 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nishanth Aravamudan <nacc@us.ibm.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Mel Gorman <mel@skynet.ie>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
In-Reply-To: <20071109182059.GJ7507@us.ibm.com>
Message-ID: <Pine.LNX.4.64.0711091021490.14929@schroedinger.engr.sgi.com>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie>
 <20071109143426.23540.44459.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0711090741120.13932@schroedinger.engr.sgi.com>
 <20071109161455.GB32088@skynet.ie> <20071109164537.GG7507@us.ibm.com>
 <1194628732.5296.14.camel@localhost> <Pine.LNX.4.64.0711090924210.14572@schroedinger.engr.sgi.com>
 <20071109181607.GI7507@us.ibm.com> <20071109182059.GJ7507@us.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007, Nishanth Aravamudan wrote:

> > Indeed, this probably needs to be validated... Sigh, more interleaving
> > of policies and everything else...
> 
> Hrm, more importantly, isn't this an existing issue? Maybe should be
> resolved separately from the one zonelist patches.

GFP_THISNODE with alloc_pages() currently yields an allocation from the 
first node of the MPOL_BIND zonelist. So its the lowest node of the set.

