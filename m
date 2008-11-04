Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbYKDXgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbYKDXgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbYKDXgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:36:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192AbYKDXgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:36:24 -0500
Date: Tue, 4 Nov 2008 15:36:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: peterz@infradead.org, rientjes@google.com, npiggin@suse.de,
       menage@google.com, dfults@sgi.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 0/7] cpuset writeback throttling
Message-Id: <20081104153610.bbfd5ed8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0811041648350.6254@quilx.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
	<20081104124753.fb1dde5a.akpm@linux-foundation.org>
	<1225831988.7803.1939.camel@twins>
	<20081104131637.68fbe055.akpm@linux-foundation.org>
	<1225833710.7803.1993.camel@twins>
	<20081104135004.f1717fcf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811041601100.5077@quilx.com>
	<20081104143534.b5c16147.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811041648350.6254@quilx.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 16:52:48 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 4 Nov 2008, Andrew Morton wrote:
> 
> > To fix this with a memcg-based throttling, the operator would need to
> > be able to create memcg's which have pages only from particular nodes.
> > (That's a bit indirect relative to what they want to do, but is
> > presumably workable).
> 
> The system would need to have the capability to find the memcg groups that 
> have dirty pages for a certain inode. Files are not constrained to nodes 
> or memcg groups.

Ah, we're talking about different things.

In a memcg implementation what we would implement is "throttle
page-dirtying tasks in this memcg when the memcg's dirty memory reaches
40% of its total".

But that doesn't solve the problem which this patchset is trying to
solve, which is "don't let all the memory in all this group of nodes
get dirty".


Yes?  Someone help me out here.  I don't yet have my head around the
overlaps and incompatibilities here.  Perhaps the containers guys will
wake up and put their thinking caps on?



What happens if cpuset A uses nodes 0,1,2,3,4,5,6,7,8,9 and cpuset B
uses nodes 0,1?  Can activity in cpuset A cause ooms in cpuset B?

