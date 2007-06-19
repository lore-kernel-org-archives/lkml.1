Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbXFSVXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbXFSVXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXFSVXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:23:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50760 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751694AbXFSVXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:23:43 -0400
Date: Tue, 19 Jun 2007 14:23:44 -0700
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: clameter@sgi.com, linux-mm@kvack.org, wli@holomorphy.com,
       linux-kernel@vger.kernel.org
Subject: Re: Some thoughts on memory policies
Message-Id: <20070619142344.db0f636c.pj@sgi.com>
In-Reply-To: <1182284690.5055.128.camel@localhost>
References: <Pine.LNX.4.64.0706181257010.13154@schroedinger.engr.sgi.com>
	<1182284690.5055.128.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The current memory policy APIs can work in such a "containerized"
> environment if we can reconcile the policy APIs' notion of nodes with
> the set of nodes that container allows.  Perhaps we need to revisit the
> "cpumemset" proposal that provides a separate node id namespace in each
> container/cpuset.

Currently, we (SGI) do this for our systems using user level library
code.

Even though that library code is LGPL licensed, it's still far less
widely distributed than the Linux kernel.  Container relative numbering
support directly in the kernel might make sense; though it would be
very challenging to provide that without breaking any existing API's
such as sched_setaffinity, mbind, set_mempolicy and various /proc
files that provide only system-wide numbering.

The advantage I had doing cpuset relative cpu and mem numbering in a
user library was that I could invent new API's that were numbered
relatively from day one.

So ... I'd likely be supportive of cpuset (or container) relative
numbering support in the kernel ... if someone can figure out how to do
it without breaking existing API's left and right.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
