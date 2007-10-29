Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbXJ2Uf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbXJ2Uf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbXJ2Ufu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:35:50 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55186 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753109AbXJ2Uft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:35:49 -0400
Date: Mon, 29 Oct 2007 13:35:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <1193670056.5035.27.camel@localhost>
Message-ID: <Pine.LNX.4.64.0710291335100.1566@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
  <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com> 
 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com> 
 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com> 
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com> 
 <20071025185506.8c373aa8.pj@sgi.com>  <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
  <1193412644.5032.13.camel@localhost>  <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
  <20071026120037.7b95a136.pj@sgi.com>  <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
  <1193433239.5032.95.camel@localhost>  <Pine.LNX.4.64.0710261415580.18139@schroedinger.engr.sgi.com>
  <1193433992.5032.102.camel@localhost>  <Pine.LNX.4.64.0710261436070.18899@schroedinger.engr.sgi.com>
 <1193670056.5035.27.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Lee Schermerhorn wrote:

> Note:  I don't [didn't] think I need to ref count the nodemasks
> associated with the mempolicies because they are allocated when the
> mempolicy is and destroyed when the policy is--not shared.  Just like
> the custom zonelist for bind policy, and we have no ref count there.
> I.e., they're protected by the mempol's ref.  However, now that you
> bring it up, I'm wondering about the effects of policy remapping, and
> whether we have the reference counting or indirect protection [mmap_sem,
> whatever] correct there in current code.  I'll have to take a look.

In that case we could just put the nodemask at the end of the mempolicy 
structure and then allocate the size needed? That way we would not need to 
deref an additional pointer?

