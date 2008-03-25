Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYCZQGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYCZQGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbYCZQGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:06:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4883 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753914AbYCZQG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:06:29 -0400
Date: Wed, 26 Mar 2008 00:10:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Mayer <ajm@sgi.com>
Cc: torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel list <linux-kernel@vger.kernel.org>,
       Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86_64: resize NR_IRQS for large machines
Message-ID: <20080325231034.GA3894@ucw.cz>
References: <Pine.SGI.3.96.1080324092858.7873204S-100000@fergus.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SGI.3.96.1080324092858.7873204S-100000@fergus.americas.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Subject: [PATCH] x86_64: resize NR_IRQS for large machines
> 
> From: Alan Mayer <ajm@sgi.com>
> 
> On machines with very large numbers of cpus, tables that are dimensioned
> by NR_IRQS get very large, especially the irq_desc table.  They are also
> very sparsely used.  When the cpu count is > MAX_IO_APICS, use MAX_IO_APICS
> to set NR_IRQS, otherwise use NR_CPUS.
> 
> Signed-off-by: Alan Mayer <ajm@sgi.com>
> 
> Reviewed-by: Christoph Lameter <clameter@sgi.com>

> ===================================================================
> --- v2.6.25-rc6.orig/include/asm-x86/irq_64.h	2008-03-19 16:52:52.000000000 -0500
> +++ v2.6.25-rc6/include/asm-x86/irq_64.h	2008-03-20 16:46:51.000000000 -0500
> @@ -10,6 +10,10 @@
>   *	<tomsoft@informatik.tu-chemnitz.de>
>   */
>  
> +#if !defined(MAX_IO_APICS)
> +#include <asm/apicdef.h>
> +#endif
> +

This is very ugly. Why not include it unconditionally -- with guard in
apicdef.h?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
