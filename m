Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbZHXVRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbZHXVRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbZHXVRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:17:14 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59649 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbZHXVRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:17:13 -0400
Subject: Re: [patch 3/4 -mm] flex_array: poison free elements
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ben Blum <bblum@google.com>
In-Reply-To: <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0908211620580.28611@chino.kir.corp.google.com>
	 <1251129384.22398.7166.camel@nimitz>
	 <alpine.DEB.2.00.0908241330361.5574@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 14:16:58 -0700
Message-Id: <1251148618.22398.8188.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 13:41 -0700, David Rientjes wrote:
> LEX_ARRAY_FREE (or an additional poison value to 
> distinguish between use-uninitialized vs. use-after-free) must be used in 
> flex_array_clear() otherwise the cgroup patchset, the only proposed user 
> of this library code, could never shrink this array when pid's are free 
> like the kmalloc vs. vmalloc patchset could do.

Are you saying that you expected it to never reallocate the array, but
have a permanent flex_array and that it just calls flex_array_clear() on
the elements that it doesn't want any more, and the array ends up
sparsely populated?  I can see why we'd need a poison value in that
case.

Or, are we just talking about a situation where we need to truncate the
pidlist?

-- Dave

