Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbXLKXYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbXLKXYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXLKXXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:23:53 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:21581 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbXLKXXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:23:52 -0500
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 18:23:52 EST
X-SBRS: None
X-MesageID: 33483321
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,154,1196658000"; 
   d="scan'208";a="33483321"
Message-ID: <475F1961.10309@citrix.com>
Date: Tue, 11 Dec 2007 15:12:33 -0800
From: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: jeremy@xensource.com, chrisw@sous-sol.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: [2.6 patch] xen: fiddle_vdso() must be __init
References: <20071211222119.GG14204@stusta.de>
In-Reply-To: <20071211222119.GG14204@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch fixes the following section mismatch:
>
> <--  snip  -->
>
> ...
> WARNING: vmlinux.o(.text+0x2589): Section mismatch: reference to .init.data:vsyscall_int80_start (between 'fiddle_vdso' and 'xen_setup_features')
>   

Jan Beulich just posted a patch to do this, which I acked.

    J

> ...
>
> <--  snip  -->
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
> bd7d683674d639a57c73b316972a28df43690a17 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index f84e772..5e24f67 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -59,7 +59,7 @@ static void xen_idle(void)
>  /*
>   * Set the bit indicating "nosegneg" library variants should be used.
>   */
> -static void fiddle_vdso(void)
> +static void __init fiddle_vdso(void)
>  {
>  	extern u32 VDSO_NOTE_MASK; /* See ../kernel/vsyscall-note.S.  */
>  	extern char vsyscall_int80_start;
>
>   

