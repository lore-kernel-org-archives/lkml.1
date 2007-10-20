Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbXJTFfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbXJTFfl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 01:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762425AbXJTFfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 01:35:18 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47604 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756646AbXJTFfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 01:35:09 -0400
Date: Sat, 20 Oct 2007 07:36:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 2.6.23-git] toplevel Makefile/depmod bugfix
Message-ID: <20071020053642.GA4535@uranus.ravnborg.org>
References: <20071020044224.DD48423A6FC@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020044224.DD48423A6FC@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 09:42:24PM -0700, David Brownell wrote:
> This removes a BASH syntax error (seen building on Ubuntu Feisty).
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 
> --- g26.orig/Makefile	2007-10-19 21:29:43.000000000 -0700
> +++ g26/Makefile	2007-10-19 18:35:32.000000000 -0700
> @@ -1507,7 +1507,7 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm
>  # and we build for the host arch
>  quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
>        cmd_depmod = \
> -	if [ -r System.map -a -x $(DEPMOD) -a "$(SUBARCH)" == "$(ARCH)" ]; then \
> +	if [ -r System.map -a -x $(DEPMOD) -a "$(SUBARCH)" = "$(ARCH)" ]; then \
>  		$(DEPMOD) -ae -F System.map                                     \
>  		$(if $(strip $(INSTALL_MOD_PATH)), -b $(INSTALL_MOD_PATH) -r)   \
>  		$(KERNELRELEASE);                                               \
> -


Took a look at 'man bash' here.
bash --version
GNU bash, version 3.2.9(1)-release (x86_64-redhat-linux-gnu)
Copyright (C) 2005 Free Software Foundation, Inc.

Accoding to man bash "==" is used to test for equality and "=" is used for assignmnet.
I assume the above is a dash syntax error (dash is default on ubuntu IIRC).

Is it truly protable with "=" or do we need to be more clever?

	Sam
