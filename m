Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbXEOPCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbXEOPCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 11:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXEOPCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 11:02:34 -0400
Received: from nemesis.fprintf.net ([66.134.112.218]:4188 "EHLO
	nemesis.fprintf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXEOPCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 11:02:33 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 11:02:33 EDT
Subject: Re: [Bugme-new] [Bug 8479] New: gettimeofday returning 1000000 in
	tv_usec on core2duo
From: Daniel Gryniewicz <dang@gentoo.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       stable@kernel.org
In-Reply-To: <20070515101758.51d6bc47.dada1@cosmosbay.com>
References: <200705150417.l4F4HlvS013354@fire-2.osdl.org>
	 <46494DFC.6080104@cosmosbay.com>
	 <20070514232301.69e27bbe.akpm@linux-foundation.org>
	 <200705150922.47702.ak@suse.de>
	 <20070515101758.51d6bc47.dada1@cosmosbay.com>
Content-Type: text/plain
Date: Tue, 15 May 2007 10:55:51 -0400
Message-Id: <1179240951.7903.0.camel@athena.fprintf.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-15 at 10:17 +0200, Eric Dumazet wrote:
> OK, here is the fix only patch, for linux-2.6.21-stable only, since 2.6.22 is already fixed.
> 
> [PATCH] x86_64 : Fix vgettimeofday()
> 
> vgettimeofday() may return some bad timeval values, (tv_usec = 1000000), because of a wrong compare.
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> 
> --- arch/x86_64/kernel/vsyscall.c
> +++ arch/x86_64/kernel/vsyscall.c
> @@ -132,7 +132,7 @@ static __always_inline void do_vgettimeo
>  
>  	/* convert to usecs and add to timespec: */
>  	tv->tv_usec += nsec_delta / NSEC_PER_USEC;
> -	while (tv->tv_usec > USEC_PER_SEC) {
> +	while (tv->tv_usec >= USEC_PER_SEC) {
>  		tv->tv_sec += 1;
>  		tv->tv_usec -= USEC_PER_SEC;
>  	}

That fixed it, thanks.

Daniel

