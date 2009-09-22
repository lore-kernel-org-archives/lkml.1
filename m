Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbZIVNib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbZIVNib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZIVNia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:38:30 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36821 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbZIVNia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=x51US7lV1AD8PbBmfrJGgd02+1L/YcJjdCjziz4Zzo8nvhQiQr8IgsPAgLOkqNtXC0
         63jwumdfq8l7AaZwf+WwZCpJGBm3lhZXZl5dvslssi2zH5bvCAlY7YctsSps0zy5A9pc
         xBqguqMvlElJIJpiu7VpAoFZ544LSV/kr441E=
MIME-Version: 1.0
In-Reply-To: <1253624054-10882-3-git-send-email-mel@csn.ul.ie>
References: <1253624054-10882-1-git-send-email-mel@csn.ul.ie>
	 <1253624054-10882-3-git-send-email-mel@csn.ul.ie>
Date: Tue, 22 Sep 2009 16:38:32 +0300
X-Google-Sender-Auth: e69b746dc2edcf2c
Message-ID: <84144f020909220638l79329905sf9a35286130e88d0@mail.gmail.com>
Subject: Re: [PATCH 2/4] slqb: Record what node is local to a kmem_cache_cpu
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <cl@linux-foundation.org>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Tue, Sep 22, 2009 at 3:54 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> When freeing a page, SLQB checks if the page belongs to the local node.
> If it is not, it is considered a remote free. On the allocation side, it
> always checks the local lists and if they are empty, the page allocator
> is called. On memoryless configurations, this is effectively a memory
> leak and the machine quickly kills itself in an OOM storm.
>
> This patch records what node ID is considered local to a CPU. As the
> management structure for the CPU is always allocated from the closest
> node, the node the CPU structure resides on is considered "local".
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

I don't understand how the memory leak happens from the above
description (or reading the code). page_to_nid() returns some crazy
value at free time? The remote list isn't drained properly?

                        Pekka
