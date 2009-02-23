Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZBWPwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZBWPwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbZBWPv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:51:57 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:35449 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755766AbZBWPv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:51:56 -0500
Date: Mon, 23 Feb 2009 10:43:20 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 04/20] Convert gfp_zone() to use a table of precalculated
 value
In-Reply-To: <200902240241.48575.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0902231042440.7790@qirst.com>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-5-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0902231003090.7298@qirst.com> <200902240241.48575.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Nick Piggin wrote:

> > Are you sure that this is a benefit? Jumps are forward and pretty short
> > and the compiler is optimizing a branch away in the current code.
>
> Pretty easy to mispredict there, though, especially as you can tend
> to get allocations interleaved between kernel and movable (or simply
> if the branch predictor is cold there are a lot of branches on x86-64).
>
> I would be interested to know if there is a measured improvement. It
> adds an extra dcache line to the footprint, but OTOH the instructions
> you quote is more than one icache line, and presumably Mel's code will
> be a lot shorter.

Maybe we can come up with a version of gfp_zone that has no branches and
no lookup?

