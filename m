Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbXK0XCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbXK0XCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbXK0XCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:02:44 -0500
Received: from r00tworld.com ([212.85.137.21]:55251 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758956AbXK0XCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:02:43 -0500
From: pageexec@freemail.hu
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       travis@sgi.com
Date: Wed, 28 Nov 2007 00:01:57 +0200
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm: Prevent dereferencing non-allocated per_cpu variables
Reply-to: pageexec@freemail.hu
CC: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Message-ID: <474CAFF5.8792.356C2F62@pageexec.freemail.hu>
In-reply-to: <20071127215054.660250000@sgi.com>
References: <20071127215052.090968000@sgi.com>, <20071127215054.660250000@sgi.com>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 28 Nov 2007 00:01:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Nov 2007 at 13:50, travis@sgi.com wrote:

> Change loops controlled by 'for (i = 0; i < NR_CPUS; i++)' to use
> 'for_each_possible_cpu(i)' when there's a _remote possibility_ of
> dereferencing a non-allocated per_cpu variable involved.

actually, it's not that remote, it happens every time
NR_CPUS > num_possible_cpus(). i ran into this myself
on a dual core box with NR_CPUS=4. due to my rewrite
of the i386 per-cpu segment handling, i actually got
a NULL deref where the vanilla kernel would be accessing
the area of [__per_cpu_start, __per_cpu_end] for each
non-possible CPU (which doesn't crash per se but is
still not correct somehow i think).

