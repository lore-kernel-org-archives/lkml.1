Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbYCCMR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbYCCMR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYCCMRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:17:48 -0500
Received: from ns.suse.de ([195.135.220.2]:43431 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbYCCMRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:17:47 -0500
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] reserve RAM below PHYSICAL_START
From: Andi Kleen <andi@firstfloor.org>
References: <20080227003325.GS28483@v2.random>
Date: Mon, 03 Mar 2008 13:17:46 +0100
In-Reply-To: <20080227003325.GS28483@v2.random> (Andrea Arcangeli's message of "Wed\, 27 Feb 2008 01\:33\:25 +0100")
Message-ID: <p73ve446lxx.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli <andrea@qumranet.com> writes:

> Hello,
>
> this patch allows to prevent linux from using the ram below
> PHYSICAL_START.
>
> The "reserved RAM" can be mapped by virtualization software with to
> create a 1:1 mapping between guest physical (bus) address and host
> physical (bus) address.

Wouldn't it be easier if your virtualization software just marked
that area reserved or unmapped in its e820 map? 

Of if you don't want that you can get the same result with mem=... 
arguments (e.g commonly used by crash dumping) 

Even if that was all not possible for some reason having CONFIG for this would
seem unfortunate for me -- i don't think users really want specially
compiled kernels for specific hypervisors. With paravirt Linux
is trying to get away from that. Some runtime setup method
would be much better.

-Andi
