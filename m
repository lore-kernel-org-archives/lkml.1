Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbYK0Mek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbYK0Mek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYK0Meb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:34:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55029 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbYK0Mea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:34:30 -0500
Date: Thu, 27 Nov 2008 13:45:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-ID: <20081127124501.GL6703@one.firstfloor.org>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com> <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain> <20081126140054.GX6703@one.firstfloor.org> <alpine.LFD.2.00.0811262237140.3325@localhost.localdomain> <20081127100602.GF6703@one.firstfloor.org> <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com> <20081127113115.GH6703@one.firstfloor.org> <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com> <20081127123257.GI6703@one.firstfloor.org> <7c86c4470811270428r76702954se8f6e005481a6a35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811270428r76702954se8f6e005481a6a35@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What if a threads reprograms the counters while another is reading them?

In the worst case you get an invalid event, which is then discarded.
I think. I've never tried to understand it in all details, but 
at least it seems to work.

> How is the buffer reset?

drivers/oprofile/cpu_buffer.c:

/* Resets the cpu buffer to a sane state. */
void cpu_buffer_reset(struct oprofile_cpu_buffer *cpu_buf)
{
        /* reset these to invalid values; the next sample
         * collected will populate the buffer with proper
         * values to initialize the buffer
         */
        cpu_buf->last_is_kernel = -1;
        cpu_buf->last_task = NULL;
}

-Andi

-- 
ak@linux.intel.com
