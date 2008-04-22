Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbYDVIht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbYDVIht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbYDVIhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:37:40 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43445 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845AbYDVIhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:37:39 -0400
Date: Tue, 22 Apr 2008 10:38:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function calls
Message-ID: <20080422083810.GA23540@uranus.ravnborg.org>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-3-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208851058-8500-3-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 09:57:28AM +0200, Jens Axboe wrote:
> This converts x86 and x86-64 to use the new helpers for
> smp_call_function() and friends, and adds support for
> smp_call_function_single().
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 87a693c..aab97e3 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -156,6 +156,11 @@ config GENERIC_PENDING_IRQ
>  	depends on GENERIC_HARDIRQS && SMP
>  	default y
>  
> +config GENERIC_SMP_HELPERS
> +	bool
> +	depends on SMP
> +	default y
> +

Hi Jens.

[Not x86 specific - it was the first patch
touching a Kconfig file]

Could we define a single config variable
in for example kernel/Kconfig(*)
like this:

config HAVE_GENERIC_SMP_HELPERS
	def_bool n

And then the archs that uses the generic SMP helpers just
do a simple:

 config X86
+	select HAVE_GENERIC_SMP_HELPERS


This is the recommended method today and is documented
in Documentation/kbuild/kconfig-language.txt if
you need a bit more intro.

(*) I know we do not have kernel/Kconfig today.
    But maybe this is a good time to add it and
    source it from arch/Kconfig

	Sam
