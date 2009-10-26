Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbZJZTKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbZJZTKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZJZTKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:10:24 -0400
Received: from bar.sig21.net ([80.81.252.164]:45172 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbZJZTKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:10:20 -0400
Date: Mon, 26 Oct 2009 20:11:14 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lguest@ozlabs.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Lguest] 2.6.32-rc5 guest crash
Message-ID: <20091026191114.GA3478@sig21.net>
References: <20091025175521.GA13300@sig21.net>
 <200910261426.05769.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910261426.05769.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.824,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 02:26:04PM +1030, Rusty Russell wrote:
> 
> Subject: x86: sidestep lguest problem by only building cmpxchg8b_emu for pre-Pentium
> 
> Arjen's 79e1dd05d1a22 "x86: Provide an alternative() based cmpxchg64()" broke
> lguest, even on systems which have cmpxchg8b support.  The emulation code
> gets used until alternatives get run, but it contains native instructions,
> not their paravirt alternatives.
> 
> The simplest fix is to turn this code off except for 386 and 486 builds.
> 
> Reported-by: Johannes Stezenbach <js@sig21.net>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> --- a/arch/x86/Kconfig.cpu
> +++ b/arch/x86/Kconfig.cpu
> @@ -400,7 +400,7 @@ config X86_TSC
>  
>  config X86_CMPXCHG64
>  	def_bool y
> -	depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
> +	depends on !M386 && !M486


FWIW, I've tested it both with original host kernel (only used recompiled
kernel as guest), and after reboot, the guest works in both cases and
the host kernel still boots with the patch applied.


Thanks,
Johannes
