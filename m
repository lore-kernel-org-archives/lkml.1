Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbYHTP05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbYHTP05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYHTP0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:26:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896AbYHTP0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:26:48 -0400
Message-ID: <48AC3789.3030305@linux-foundation.org>
Date: Wed, 20 Aug 2008 10:26:01 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       tokunaga.keiich@jp.fujitsu.com
Subject: Re: [RFC][PATCH 0/2] Quicklist is slighly problematic.
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <48AC25E7.4090005@linux-foundation.org> <2f11576a0808200749x956cc3fsef5d0eeace243410@mail.gmail.com>
In-Reply-To: <2f11576a0808200749x956cc3fsef5d0eeace243410@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> So, if possible, I'd like to make short term solution.
> I believe nobody oppose quicklist reducing. it is defenitly too fat.

Correct.

>> Good fixup but I would think that some more radical rework is needed.
>> Maybe some of this needs to vanish into the TLB handling logic?
> 
> What do you think wrong TLB handing?
> pure performance issue?

The generic TLB code could be made to do allow the allocation, the batching
and freeing of the pages. Would remove the need for quicklists for some uses.

>
> Do you have any page allocator enhancement plan?
> Can I help it?

A simple approach would be to use the queueing method used in quicklists in
the page allocator hotpath. But the devil is in the details .... There are
numerous checks for the type of page that are done by the page allocator and
not for the quicklists. Somehow we need to work around these.

