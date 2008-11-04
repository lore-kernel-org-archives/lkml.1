Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbYKDWgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbYKDWgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756368AbYKDWgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:36:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755696AbYKDWgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:36:16 -0500
Date: Tue, 4 Nov 2008 14:35:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: peterz@infradead.org, rientjes@google.com, npiggin@suse.de,
       menage@google.com, dfults@sgi.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 0/7] cpuset writeback throttling
Message-Id: <20081104143534.b5c16147.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0811041601100.5077@quilx.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
	<20081104124753.fb1dde5a.akpm@linux-foundation.org>
	<1225831988.7803.1939.camel@twins>
	<20081104131637.68fbe055.akpm@linux-foundation.org>
	<1225833710.7803.1993.camel@twins>
	<20081104135004.f1717fcf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811041601100.5077@quilx.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 16:17:52 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 4 Nov 2008, Andrew Morton wrote:
> 
> > What are the alternatives here?  What do we need to do to make
> > throttling a per-memcg thing?
> 
> Add statistics to the memcg lru and then you need some kind of sets of 
> memcgs that are represented by bitmaps or so attached to an inode.
> 
> > The patchset is badly misnamed, btw.  It doesn't throttle writeback -
> > in fact several people are working on IO bandwidth controllers and
> > calling this thing "writeback throttling" risks confusion.
> 
> It is limiting dirty pages and throttling the dirty rate of applications 
> in a  NUMA system (same procedure as we do in non NUMA). The excessive 
> dirtying without this patchset can cause OOMs to occur on NUMA systems.

yup.

To fix this with a memcg-based throttling, the operator would need to
be able to create memcg's which have pages only from particular nodes. 
(That's a bit indirect relative to what they want to do, but is
presumably workable).

But do we even have that capability now?

