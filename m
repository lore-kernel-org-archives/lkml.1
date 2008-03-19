Return-Path: <linux-kernel-owner+w=401wt.eu-S944044AbYCTAQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944044AbYCTAQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938468AbYCSXfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:35:16 -0400
Received: from relay2.sgi.com ([192.48.171.30]:32884 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933575AbYCSXfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:13 -0400
Date: Wed, 19 Mar 2008 16:33:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [0/2] vmalloc: Add /proc/vmallocinfo to display mappings
In-Reply-To: <20080319150704.d3f090e6.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803191628480.4070@schroedinger.engr.sgi.com>
References: <20080318222701.788442216@sgi.com> <20080319111943.0E1B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <20080319150704.d3f090e6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008, Andrew Morton wrote:

> I was just about to ask whether we actually need the feature - I don't
> recall ever having needed it, nor do I recall seeing anyone else need it.
> 
> Why is it useful?

It allows to see the users of vmalloc. That is important if vmalloc space 
is scarce (i386 for example).

And its going to be important for the compound page fallback to vmalloc.
Many of the current users can be switched to use compound pages with
fallback. This means that the number of users of vmalloc is reduced and 
page tables no longer necessary to access the memory.
/proc/vmallocinfo allows to review how that reduction occurs.

If memory becomes fragmented and larger order allocations are no longer 
possible then /proc/vmallocinfo allows to see which compound 
page allocations fell back to virtual compound pages. That is important 
for new users of virtual compound pages. Such as order 1 stack allocation 
etc that may fallback to virtual compound pages in the future.

