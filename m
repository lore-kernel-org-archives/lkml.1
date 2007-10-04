Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbXJDJNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbXJDJNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbXJDJNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:13:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbXJDJNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:13:05 -0400
From: Andi Kleen <ak@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [14/18] Configure stack size
Date: Thu, 4 Oct 2007 11:11:04 +0200
User-Agent: KMail/1.9.1
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, travis@sgi.com
References: <20071004035935.042951211@sgi.com> <20071004040004.936534357@sgi.com>
In-Reply-To: <20071004040004.936534357@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710041111.05141.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2007 05:59, Christoph Lameter wrote:
> Make the stack size configurable now that we can fallback to vmalloc if
> necessary. SGI NUMA configurations may need more stack because cpumasks
> and nodemasks are at times kept on the stack.  With the coming 16k cpu 
> support 

Hmm, I was told 512 byte cpumasks for x86 earlier. Why is this suddenly 2K? 

2K is too much imho. If you really want to go that big you have
to look in allocating them all separately imho. But messing
with the stack TLB entries and risking more TLB misses 
is not a good idea.

-Andi
