Return-Path: <linux-kernel-owner+w=401wt.eu-S933476AbYAaMf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbYAaMf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764649AbYAaMfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:35:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33696 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764090AbYAaMfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:35:15 -0500
Date: Thu, 31 Jan 2008 13:35:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PATCH] x86_64: fix comments in vmlinux_64.lds
Message-ID: <20080131123503.GG12571@elte.hu>
References: <200801302348.37990.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801302348.37990.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

>  ENTRY(startup_64)
>  SECTIONS
>  {
> -	/* Be careful parts of head_64.S assume startup_64 is at
> +	/* Be careful parts of head_64.S assume startup_32 is at
>  	 * address 0.
>  	 */
>  	. = 0;

but this linker script rule is about startup_64, not about startup_32.

startup_32 does exist on 64-bit too (and is 32-bit code), but it's 
linked to a different address that is not 0:

 ffffffff806c23c0 r startup_32

startup_64 is at offset 0:

 ffffffff80200000 T startup_64

So your patch looks wrong to me.

	Ingo
