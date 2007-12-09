Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbXLIAZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbXLIAZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 19:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbXLIAZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 19:25:31 -0500
Received: from fmailhost04.isp.att.net ([207.115.11.54]:45662 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbXLIAZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 19:25:30 -0500
X-Originating-IP: [68.222.94.40]
Date: Sat, 8 Dec 2007 18:25:28 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Allow (O=...) from file
Message-ID: <20071208182528.499f63ed@osprey.hogchain.net>
In-Reply-To: <20071208201409.GA13826@uranus.ravnborg.org>
References: <20071204210433.4d7ee66c@osprey.hogchain.net>
	<20071205210003.GA15366@uranus.ravnborg.org>
	<20071205213126.43548ccf@osprey.hogchain.net>
	<20071208201409.GA13826@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 21:14:09 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> Jay - can I ask you to try out following patch.

Hello Sam,

Yes, your patch works for me.

Thank you very much.

> diff --git a/Makefile b/Makefile
> index a5252f4..7fb1a2c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -118,9 +118,6 @@ saved-output := $(KBUILD_OUTPUT)
>  KBUILD_OUTPUT := $(shell cd $(KBUILD_OUTPUT) && /bin/pwd)
>  $(if $(KBUILD_OUTPUT),, \
>       $(error output directory "$(saved-output)" does not exist))
> -# Check that OUTPUT directory is not the same as where we have
> kernel src -$(if $(filter-out $(KBUILD_OUTPUT),$(shell /bin/pwd)),, \
> -     $(error Output directory (O=...) specifies kernel src dir))
>  
>  PHONY += $(MAKECMDGOALS) sub-make
>  
> diff --git a/scripts/mkmakefile b/scripts/mkmakefile
> index ee39fac..9ad1bd7 100644
> --- a/scripts/mkmakefile
> +++ b/scripts/mkmakefile
> @@ -11,6 +11,12 @@
>  
>  
>  test ! -r $2/Makefile -o -O $2/Makefile || exit 0
> +# Only overwrite automatically generated Makefiles
> +# (so we do not overwrite kernel Makefile)
> +if ! grep -q Automatically $2/Makefile
> +then
> +	exit 0
> +fi
>  echo "  GEN     $2/Makefile"
>  
>  cat << EOF > $2/Makefile
> --
