Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbYCIMFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbYCIMFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 08:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbYCIMFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 08:05:04 -0400
Received: from saeurebad.de ([85.214.36.134]:43575 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbYCIMFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 08:05:03 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
	<20080309111456.GA21690@elte.hu>
Date: Sun, 09 Mar 2008 13:03:29 +0100
In-Reply-To: <20080309111456.GA21690@elte.hu> (Ingo Molnar's message of "Sun,
	9 Mar 2008 12:14:56 +0100")
Message-ID: <87ve3w9ka6.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo Molnar <mingo@elte.hu> writes:

> hm. I think we should not let this much RAM hang around in a 
> special-purpose allocator like quicklists. Shouldnt the quicklists be 
> temporary in nature, and be trimmed much more agressively?
>
> in fact, we have a check_pgt_cache() call in cpu_idle(), which does:
>
>         quicklist_trim(0, pgd_dtor, 25, 16);
>
> but it appears we dont do quicklist trimming anywhere else! So if a 
> system has no idle time, the quicklist can grow unbounded, and that's a 
> real memory leak IMO.

It is also called from tlbu_finish_mmu().

	Hannes
