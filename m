Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbXLKRhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbXLKRhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXLKRg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:36:56 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40808 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbXLKRgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:36:55 -0500
Date: Tue, 11 Dec 2007 18:38:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Jay Cliburn <jacliburn@bellsouth.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Re-enable Makefile generation in a new O=... directory
Message-ID: <20071211173837.GC26368@uranus.ravnborg.org>
References: <20071211122208.4050.34387.stgit@cheypa.inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211122208.4050.34387.stgit@cheypa.inria.fr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 01:22:08PM +0100, Guillaume Chazarain wrote:
> The patch kbuild: fix building with O=.. options
> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=18c32dac75b187d1a4e858f3cfdf03e844129f5e
> disabled the creation of a Makefile in a new O=... directory. Restore it.
> 
> Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>

Crap - thanks for noticing this.
I will push this fix.

	Sam
> ---
> 
>  scripts/mkmakefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/mkmakefile b/scripts/mkmakefile
> index 9ad1bd7..e0f54b9 100644
> --- a/scripts/mkmakefile
> +++ b/scripts/mkmakefile
> @@ -13,7 +13,7 @@
>  test ! -r $2/Makefile -o -O $2/Makefile || exit 0
>  # Only overwrite automatically generated Makefiles
>  # (so we do not overwrite kernel Makefile)
> -if ! grep -q Automatically $2/Makefile
> +if test -e $2/Makefile && ! grep -q Automatically $2/Makefile
>  then
>  	exit 0
>  fi
