Return-Path: <linux-kernel-owner+w=401wt.eu-S1161095AbXCGHTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161095AbXCGHTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161103AbXCGHTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:19:46 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:27524 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161095AbXCGHTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:19:45 -0500
Date: Tue, 6 Mar 2007 23:19:09 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307071909.GI18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@suse.de>,
	Linux Memory Management <linux-mm@kvack.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306225101.f393632c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 10:51:01PM -0800, Andrew Morton wrote:
> Does anybody really pass a NULL `type' arg into filemap_nopage()?

The major vs. minor fault accounting patch that introduced the argument
didn't make non-NULL type arguments a requirement. It's essentially an
optional second return value and the NULL pointer represents the caller
choosing to ignore it. I'm not sure I actually liked that aspect of it,
but that's how it ended up going in. I think it had something to do
with driver churn clashing with the sweep at the time of the merge. I'd
rather the argument be mandatory and defaulted to VM_FAULT_MINOR.

It's something of a non-answer, though, since it only discusses a
convention as opposed to reviewing specific callers of filemap_nopage().
NULL type arguments to ->nopage() are rare at most, and could be easily
eliminated, at least for in-tree drivers.

egrep -nr 'nopage.*NULL' . 2>/dev/null | grep -v '^Bin' on a current
git tree yields zero matches.


-- wli
