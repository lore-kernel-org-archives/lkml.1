Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZDOTjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZDOTjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZDOTiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:38:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32890 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbZDOTix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:38:53 -0400
Date: Wed, 15 Apr 2009 21:37:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] Add -Werror to arch/x86/ files only and fix
	warnings
Message-ID: <20090415193758.GA32675@elte.hu>
References: <1239793458.7653.12.camel@ht.satnam> <20090415111355.GB27727@elte.hu> <1239798333.7653.15.camel@ht.satnam> <1239810924.2996.1.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239810924.2996.1.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> +config ALLOW_X86_WARNINGS
> +	bool "Continue building x86 despite compiler warnings"
> +	default n
> +	depends on ALLOW_WARNINGS
> +	depends on DEBUG_KERNEL
> +	help
> +	  By enabling this option you will disable -Werror on building
> +	  x86 C files only.

no, it should be something like this:

config ALLOW_X86_WARNINGS
	bool "Continue building x86 despite compiler warnings" if DEBUG_KERNEL
	default y
	help
	  By disabling this option you will enable -Werror builds:
	  i.e. any compiler warning will generate a build 
	  failure. (On arch/x86 files only)

	  Disabe this only if you have a reasonably recent compiler 
	  that does not emit bogus warnings and if you want to help 
	  with fixing warnings. Also choose this if you are an x86 
	  developer trying to make sure that the patches you submit 
	  build warning-free. (The rest of the kernel can emit lots 
	  of build warnings - so your own warnings might be easy to 
	  miss.)

	  Choose Y if unsure.

Note the differences: this will be properly kept 'Y' in most 
situations (allyes, allmod, allno). Also note the explicit 
explanation in the help text.

	Ingo
