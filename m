Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab0BQQF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:05:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:42492 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0BQQFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:05:25 -0500
Date: Wed, 17 Feb 2010 17:05:20 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Yinghai Lu <yinghai@kernel.org>, akpm@linux-foundation.org,
       jbohac@suse.cz
Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
Message-ID: <20100217160520.GA28084@midget.suse.cz>
References: <1266357790-8962-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266357790-8962-1-git-send-email-trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 11:03:10PM +0100, Thomas Renninger wrote:
> with MAX_LOOPS something like 1E9 this would leave plenty of time for the
> pending IRQs to be cleared and would and still cause at most a second of delay
> if the loop were to lock-up for whatever reason.
...
> +	int i, j, acked = 0, max_loops = 0x1E9;

I meant 1E9 == 1000000, not 0x1E9, just to give the kernel a
chance to boot (with a delay) if something is completely wrong.
0x1E9 might be too small.

I also think a warning should be printed in case max_loops decreases to
zero:

> +	    max_loops--;
> +        } while (queued && max_loops > 0);

+	WARN_ON(!max_loops)

Thanks,

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

