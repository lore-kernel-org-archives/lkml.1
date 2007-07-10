Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbXGJUTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbXGJUTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbXGJUTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:19:46 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:45082 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233AbXGJUTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:19:46 -0400
Date: Tue, 10 Jul 2007 23:19:23 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: avoiding rejects
Message-ID: <20070710201923.GA22675@localdomain>
References: <20070710124422.a52b0458.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710124422.a52b0458.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 12:44:22PM -0700, Andrew Morton wrote:
> 
> There are many situations where patching the kernel involves adding a new
> item to a list, such as:
> 
> - adding a makefile line
> - adding a new #include
> - adding a new Kconfig entry
> - adding a new PCI ID
> - adding a record to feature-removal.txt
> - adding a new sysctl table entry
> - etc
> 
> Of course, everyone just sticks the new entry at the end of the existing
> entries.  This strategy carefully maximises the opportunity for patch
> rejects and leads to unhappiness.
> 
> Most of these lists are unordered anyway, so inserting the new item at a
> randomly-chosen position is a better approach than just appending it.

AFAIK some Kconfig entries do have some importance to order (take 
kernel/Kconfig.hz for example, though it's not a good one, not long 
enough).

I think that random insertions can hurt on the readability side. So, here's
a list of more ways to discuss:

1. How about adding a context-aware logic to the merging process? (i.e, 
project-specific "plugins") That is, beside the regular 3-line context, 
the merging logic can be a aware of particular file formats, whether it's a 
Kconfig tree-like structure or list of lines all starting with a prefix of 
'#include'. 

2. Alternatively, these special one-liner diff hunks can be generated with
smaller context space (2, 1, or even no lines). This means instead of 
adding context-awareness to the merger process, add context-awareness
to the diff generator. The other 'more complex' code modifications hunks 
must remain with a context of 3 lines.

3. Another option is to come up with file formats that have '3 space 
lines' dilimeters between items (it wouldn't make sense for #include, but 
for PCI IDs it might be worth it).

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
