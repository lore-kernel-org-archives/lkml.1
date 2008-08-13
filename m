Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbYHMOcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbYHMOcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYHMOcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:32:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbYHMOcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:32:03 -0400
Message-ID: <48A2F030.9080301@linux-foundation.org>
Date: Wed, 13 Aug 2008 09:31:12 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <48986AC6.5030406@linux-foundation.org>	 <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <48A2DD2C.3090602@linux-foundation.org> <2f11576a0808130714k2cd031c4nd6eea3506831cac9@mail.gmail.com>
In-Reply-To: <2f11576a0808130714k2cd031c4nd6eea3506831cac9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> 
> I don't mesure it yet. I don't like this patch.
> maybe, it decrease other typical benchmark.

Yes but running with this patch would allow us to verify that we understand
what is causing the problem. There are other solutions like skipping to the
next partial slab on the list that could fix performance issues that the patch
may cause. A test will give us:

1. Confirmation that the memory use is caused by the trylock.

2. Some performance numbers. If these show a regression then we have some
markers that we can measure other solutions against.

