Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbYFDOpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbYFDOpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbYFDOpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:45:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3529 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752845AbYFDOpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:45:23 -0400
Date: Wed, 4 Jun 2008 16:17:15 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alok Kataria <akataria@vmware.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zachary Amsden <zach@vmware.com>,
       Sahil Rihan <srihan@vmware.com>
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
Message-ID: <20080604141714.GA6140@ucw.cz>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> @@ -123,6 +123,8 @@
>  		(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
>  		cpu_khz = calculate_cpu_khz();
>  
> +	lpj_tsc = ((unsigned long)cpu_khz * 1000)/HZ;
> +

No. Some cpus do one loop per tick, some do two loops per tick, and
there are probably weird cpus, too.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
