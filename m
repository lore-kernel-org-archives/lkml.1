Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbXIQRF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbXIQRF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbXIQRFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:05:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbXIQRFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:05:47 -0400
Message-ID: <46EEB3AC.20205@redhat.com>
Date: Mon, 17 Sep 2007 13:04:44 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Anton Altaparmakov <aia21@cam.ac.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       marc.smith@esmail.mcc.edu
Subject: Re: VM/VFS bug with large amount of memory and file systems?
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk> <13126578-A4F8-43EA-9B0D-A3BCBFB41FEC@cam.ac.uk> <DC408F26-E53F-4F27-9DEF-E996401D95FB@cam.ac.uk> <200709170828.01098.nickpiggin@yahoo.com.au>
In-Reply-To: <200709170828.01098.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> (Rik has a patch sitting in -mm I believe which would make this problem
> even worse, by doing even less highmem scanning in response to lowmem
> allocations). 

My patch should not make any difference here, since
balance_pgdat() already scans the zones from high to
low and sets an end_zone variable that determines the
highest zone to scan.

All my patch does is make sure that we do not try to
reclaim excessive amounts of dma or low memory when
a higher zone is full.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
