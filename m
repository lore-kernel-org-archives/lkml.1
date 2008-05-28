Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYE1UFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYE1UFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbYE1UFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:05:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36130 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYE1UFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:05:31 -0400
Message-ID: <483DBA85.2060502@cs.helsinki.fi>
Date: Wed, 28 May 2008 23:03:17 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
       cooloney@kernel.org
CC: akpm@linux-foundation.org, dhowells@redhat.com, mpm@selenic.com,
       clameter@sgi.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
References: <Pine.LNX.4.64.0805281646470.27125@sbz-30.cs.Helsinki.FI> <20080528153648.GA27783@linux-sh.org>
In-Reply-To: <20080528153648.GA27783@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing linux-kernel)

Paul Mundt wrote:
> I have no idea why you are maintaining the page->index case here, it's
> completely broken for page cache pages. Unless someone more familiar with
> the page->index BUG_ON() tests objects, the BUG_ON() there should be
> removed completely. Neither Christoph nor I were able to work out what the
> point of the page->index tests were, and no one else has spoken up about
> them, so it's likely safe to treat them as bogus.

We use kobjsize() for pointers returned from do_mmap() which is why I 
kept the page->index case. Are we using PageCompound for those as well?

Paul Mundt wrote:
> SLOB on nommu will oops on any page cache page in the current git kernels
> until those BUG_ON()'s are killed. The more distressing thing is the fact
> that the blackfin people have been patching SLOB when it's obvious that
> they haven't been testing (ie, even booting!) it.

Hmm...
