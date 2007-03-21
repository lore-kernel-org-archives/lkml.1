Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbXCUMBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbXCUMBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbXCUMBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:01:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbXCUMBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:01:52 -0400
Message-ID: <46011E8F.2000109@redhat.com>
Date: Wed, 21 Mar 2007 08:01:19 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nikita Danilov <nikita@clusterfs.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] split file and anonymous page queues #3
References: <46005B4A.6050307@redhat.com>	<17920.61568.770999.626623@gargle.gargle.HOWL>	<460115D9.7030806@redhat.com> <17921.7074.900919.784218@gargle.gargle.HOWL>
In-Reply-To: <17921.7074.900919.784218@gargle.gargle.HOWL>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nikita Danilov wrote:

> Probably I am missing something, but I don't see how that can help. For
> example, suppose (for simplicity) that we have swappiness of 100%, and
> that fraction of referenced anon pages gets slightly less than of file
> pages. get_scan_ratio() increases anon_percent, and shrink_zone() starts
> scanning anon queue more aggressively. As a result, pages spend less
> time there, and have less chance of ever being accessed, reducing
> fraction of referenced anon pages further, and triggering further
> increase in the amount of scanning, etc. Doesn't this introduce positive
> feed-back loop?

It's a possibility, but I don't think it will be much of an
issue in practice.

If it is, we can always use refaults as a correcting
mechanism - which would have the added benefit of being
able to do streaming IO without putting any pressure on
the active list, essentially clock-pro replacement with
just some tweaks to shrink_list()...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
