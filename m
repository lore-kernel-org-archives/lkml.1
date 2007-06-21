Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbXFUQFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbXFUQFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXFUQFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:05:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbXFUQFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:05:09 -0400
Date: Thu, 21 Jun 2007 09:03:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Dave Jones <davej@redhat.com>, Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [PATCH] Alternative fix for kprobes&DEBUG_RODATA was Re: [1/2]
 2.6.22-rc5: known regressions with patches
In-Reply-To: <200706211119.07754.ak@suse.de>
Message-ID: <alpine.LFD.0.98.0706210902380.3593@woody.linux-foundation.org>
References: <467543FA.60905@googlemail.com> <20070620230751.GA15092@redhat.com>
 <alpine.LFD.0.98.0706201647350.3593@woody.linux-foundation.org>
 <200706211119.07754.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Andi Kleen wrote:

> Ok, here's a patch to do this. With that 55181000cd60334fe920c65ffbcdfe0e3f1de406
> should be reverted because it isn't needed anymore.

This seems buggy:

> +	int notext = 0;
>  
> +#ifdef CONFIG_KPROBES
> +	notext = 1;
> +#endif
>  #ifdef CONFIG_HOTPLUG_CPU
>  	/* It must still be possible to apply SMP alternatives. */
> -	if (num_possible_cpus() <= 1)
> +	notext = (num_possible_cpus() > 1);
>  #endif

The CONFIG_HOTPLUG_CPU case will overwrite the CONFIG_KPROBES, and turn it 
back to zero for a single CPU.

		Linus
