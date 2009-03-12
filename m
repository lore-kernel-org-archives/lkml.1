Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbZCLBDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbZCLBDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 21:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbZCLBDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 21:03:35 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45839 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZCLBDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 21:03:34 -0400
Date: Wed, 11 Mar 2009 18:03:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
Message-ID: <20090312010330.GK7086@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com> <alpine.DEB.1.10.0903091448110.20314@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903091448110.20314@qirst.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 02:50:06PM -0400, Christoph Lameter wrote:
> Again these are fastpath modifications.
> 
> Scanning the partial list for matching nodes is an expensive operation.
> 
> Adding RCU into the fast paths is also another big worry.

Hello, Christoph,

Adding synchronize_rcu() into a fast path would certainly be a problem,
but call_rcu() should be OK.  If the data structure is updated often
(old elements removed and new elements added), then the cache misses
from elements that were removed, went cache-cold, and then were added
again could potentially cause trouble, but read-mostly data structures
should be OK.

Or were you worried about some other aspect of RCU overhead?

							Thanx, Paul
