Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbXISIaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbXISIaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbXISIaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:30:12 -0400
Received: from ns.suse.de ([195.135.220.2]:51783 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbXISIaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:30:11 -0400
To: "David J. Wilder" <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (updated)
References: <1190177218.3190.18.camel@lc4eb748232119.ibm.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 19 Sep 2007 10:30:07 +0200
In-Reply-To: <1190177218.3190.18.camel@lc4eb748232119.ibm.com>
Message-ID: <p736427vz00.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"David J. Wilder" <dwilder@us.ibm.com> writes:

Not having read the whole thing; just something I noticed.

Gut feeling is that you have too many knobs and options and 
some overengineering though -- simplifying it would be a good thing.

> +
> +#define TRACE_PRINTF_TMPBUF_SIZE (1024)
> +static char trace_tmpbuf[NR_CPUS][TRACE_PRINTF_TMPBUF_SIZE];

That definitely needs to be a per CPU variable. Imagine
what happens on a NR_CPUS==4096 kernel.  In general when 
you have a NR_CPUS indexed array you're likely doing something
wrong. Yes there are still places in the main tree who do that,
but most of them need to be fixed.

-Andi
