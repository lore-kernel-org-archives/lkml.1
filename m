Return-Path: <linux-kernel-owner+w=401wt.eu-S1761006AbZJNV4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761006AbZJNV4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759375AbZJNV4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:56:39 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:53891 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756974AbZJNV4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:56:38 -0400
From: Frans Pop <elendil@planet.nl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
Date: Wed, 14 Oct 2009 23:55:58 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.01.0910131100180.26777@localhost.localdomain> <alpine.DEB.1.00.0910131649280.24112@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0910131649280.24112@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910142356.00895.elendil@planet.nl>
X-OriginalArrivalTime: 14 Oct 2009 21:56:01.0006 (UTC) FILETIME=[1E3918E0:01CA4D19]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009, David Rientjes wrote:
> On Tue, 13 Oct 2009, Linus Torvalds wrote:
> > Let's keep the old behavior by making the AUTO option an three-way
> > choice ("none", "short", "auto"), and making sure that it actually
> > takes work to choose "none" (and that "make oldconfig" doesn't choose
> > it unless you explicitly made the choice before - so people who just
> > re-use old .config files wouldn't get "none" by mistake).

I'm working on a patch that implements this; will post it later.

> I don't think you want to do that because it would require the .config
> to be posted on bug reports, for example, to determine the setting of
> CONFIG_LOCALVERSION_AUTO before you can interpret the kernel version. 
> In other words, you wouldn't know that "2.6.32-rc4" is actually 200
> commits beyond the actual release unless you also know that the .config
> has CONFIG_LOCALVERSION_AUTO="none".

Even with this patch you can never be 100% sure of that, for example 
because you cannot be 100% certain that a kernel was built from a tree 
that's under revision control. The most *any* change can do is increase 
the likelyhood that we get that information in the version number.

Will explain more in a different reply later.

> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  Makefile |   32 ++++++++++++++++++++------------
>  1 files changed, 20 insertions(+), 12 deletions(-)
>
> diff --git a/Makefile b/Makefile
> --- a/Makefile
> +++ b/Makefile
> @@ -898,9 +898,13 @@ $(vmlinux-dirs): prepare scripts
>  #	  $(localver)
>  #	    localversion*		(files without backups, containing '~')
>  #	    $(CONFIG_LOCALVERSION)	(from kernel config setting)
> -#	  $(localver-auto)		(only if CONFIG_LOCALVERSION_AUTO is set)
> -#	    ./scripts/setlocalversion	(SCM tag, if one exists)
> -#	    $(LOCALVERSION)		(from make command line if provided)
> +#	    $(LOCALVERSION)		(from make command line, if provided)
> +#	  $(localver-extra)
> +#	    $(scm-identifier)		(unique SCM tag, if one exists)
> +#	      ./scripts/setlocalversion	(only with CONFIG_LOCALVERSION_AUTO)
> +#	      .scmversion		(only with CONFIG_LOCALVERSION_AUTO)
> +#	    +				(only without CONFIG_LOCALVERSION_AUTO
> +#					 and repository is at non-tagged commit)
>  #
>  #  Note how the final $(localver-auto) string is included *only* if the

You forgot to change the $(localver-auto) here; and maybe also remove that 
leading space in this line.
