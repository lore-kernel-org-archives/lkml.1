Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbYD3Gip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbYD3Gip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbYD3Gig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:38:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbYD3Gig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:38:36 -0400
Date: Tue, 29 Apr 2008 23:38:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com
Subject: Re: sparc64 bootup regression...
Message-Id: <20080429233832.168fb6ee.akpm@linux-foundation.org>
In-Reply-To: <20080429.231241.221824292.davem@davemloft.net>
References: <20080429.231241.221824292.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 23:12:41 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> 
> This commit causes bootup failures on sparc64:
> 
> commit 86f6dae1377523689bd8468fed2f2dd180fc0560
> Author: Yasunori Goto <y-goto@jp.fujitsu.com>
> Date:   Mon Apr 28 02:13:33 2008 -0700
> 
>     memory hotplug: allocate usemap on the section with pgdat
>     
>     Usemaps are allocated on the section which has pgdat by this.
>     
>     Because usemap size is very small, many other sections usemaps are allocated
>     on only one page.  If a section has usemap, it can't be removed until removing
>     other sections.  This dependency is not desirable for memory removing.
>     
>     Pgdat has similar feature.  When a section has pgdat area, it must be the last
>     section for removing on the node.  So, if section A has pgdat and section B
>     has usemap for section A, Both sections can't be removed due to dependency
>     each other.
>     
>     To solve this issue, this patch collects usemap on same section with pgdat.
>     If other sections doesn't have any dependency, this section will be able to be
>     removed finally.

Thanks.  Does a straightforward revert fix it?  If so, we could do that while heads
are being scratched.
