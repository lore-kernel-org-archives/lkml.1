Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbZDTNLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbZDTNLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 09:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbZDTNKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 09:10:54 -0400
Received: from relay1.sgi.com ([192.48.179.29]:51446 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752519AbZDTNKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 09:10:53 -0400
Date: Mon, 20 Apr 2009 08:10:49 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - Memoryless nodes
Message-ID: <20090420131049.GA11839@sgi.com>
References: <20090417142242.GA23743@sgi.com> <87hc0mqqtd.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hc0mqqtd.fsf@basil.nowhere.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 11:00:46AM +0200, Andi Kleen wrote:
> Jack Steiner <steiner@sgi.com> writes:
> 
> > Add support for nodes that have cpus but no memory.
> > The current code was failing to add these nodes
> > to the nodes_present_map.
> 
> That was intentional because a node is defined as an area of memory
> and an area of memory without memory didn't seem to make sense.
> I still don't think it does. Instead the CPUs are assigned
> to nearby nodes. Back then the generic code also couldn't deal
> with them at all, so you might well run into more problems.


Nodes can also be viewed as a collection of cpus and memory that are
located "close together" - ie., same PXM in the SRAT. Normally nodes will
have both memory & cpus but in theory either cpus or memory could be
missing.

I have run a number of tests of nodes with cpus only and so far have not
seen any issues. I certainly won't rule out problems but have not seen
them yet.

If there are any corner cases that you are aware of, let me know & I can
do some more targeted testing.

(Note: this is not a bizarre end case that I'm trying to fix. UV actually
has blades with cpus and no memory available to the OS.)

--- jack

