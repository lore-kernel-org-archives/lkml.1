Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYIQOvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYIQOvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYIQOvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:51:14 -0400
Received: from smtp2a.orange.fr ([80.12.242.140]:31258 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYIQOvN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:51:13 -0400
X-ME-UUID: 20080917145110903.160B5700008E@mwinf2a18.orange.fr
Message-ID: <48D1194D.3060003@cosmosbay.com>
Date: Wed, 17 Sep 2008 16:50:53 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #11308] tbench regression on each kernel release from	2.6.22
 -&gt; 2.6.28
References: <1221306287.5213.111.camel@marge.simson.net>	 <48CD1D25.9080301@linux-foundation.org>	 <1221421907.4597.24.camel@marge.simson.net>	 <1221475440.4784.39.camel@marge.simson.net>	 <1221568105.5020.17.camel@marge.simson.net>	 <Pine.LNX.4.64.0809161700020.1034@wrl-59.cs.helsinki.fi>	 <1221626391.5043.13.camel@marge.simson.net>	 <1221627676.5125.3.camel@marge.simson.net> <20080917104044.GC18764@elte.hu>	 <1221651701.5102.17.camel@marge.simson.net> <20080917124943.GA7738@elte.hu> <1221657111.5511.14.camel@marge.simson.net> <48D11871.4090805@cosmosbay.com>
In-Reply-To: <48D11871.4090805@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Mike Galbraith a écrit :

>> I sure hope it's something like ping-pong, it's driving me NUTS.
> 
> Could you please try following patch ?
> 
> [PATCH] security_ops moved to read_mostly section
> 
> "struct security_operations *security_ops" should be moved to 
> read_mostly section in order to NOT let it share a cache line with higly 
> modified variables.
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> 
> diff --git a/security/security.c b/security/security.c
> index 3a4b4f5..0b13d65 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -24,7 +24,7 @@ static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1];
> extern struct security_operations default_security_ops;
> extern void security_fixup_ops(struct security_operations *ops);
> 
> -struct security_operations *security_ops;    /* Initialized to NULL */
> +struct security_operations *security_ops __read_mostly;e

Sorry for the extra 'e' at the end of this line, please remove it :)

> 
> /* amount of vm to protect from userspace access */
> unsigned long mmap_min_addr = CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR;
> 



