Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbZCTQKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbZCTQKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbZCTQJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:09:55 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:59549 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbZCTQJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:09:54 -0400
Date: Fri, 20 Mar 2009 12:07:22 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/25] Cleanup and optimise the page allocator V5
In-Reply-To: <20090320153723.GO24586@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903201205260.18010@qirst.com>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903201059240.3740@qirst.com> <20090320153723.GO24586@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Mel Gorman wrote:

> good idea one way or the other. Course, this meant a search of the PCP
> lists or increasing the size of the PCP structure - swings and
> roundabouts :/

The PCP list structure irks me a bit. Manipulating doubly linked lists
means touching at least 3 cachelines. Is it possible to go to a simple
linked list (one cacheline to be touched)? Or an array of pointers to
pages instead (one cacheline may contian multiple pointers to pcp pages
which means multiple pages could be handled with a single cacheline)?
