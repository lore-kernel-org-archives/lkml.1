Return-Path: <linux-kernel-owner+w=401wt.eu-S932833AbXBWUjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833AbXBWUjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933202AbXBWUjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:39:15 -0500
Received: from main.gmane.org ([80.91.229.2]:48471 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833AbXBWUjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:39:14 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: [PATCH] Allow kernel to build on Cygwin
Date: Fri, 23 Feb 2007 20:37:07 +0000 (UTC)
Message-ID: <loom.20070223T213146-410@post.gmane.org>
References: <20070223034343.GA3320@plexity.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.57.151.96 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061219 Iceape/1.0.7 (Debian-1.0.7-3))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Deepak Saxena <dsaxena <at> plexity.net> writes:

> 
> 
> This patch contains a set of small fixes to allow the kernel to build under
> the Cygwin environment, which is unfortunately used by more people than
> one would think in the embedded world. :(
Yes, I did similar patch, and there are needed for everything (busybox, 
glibc, ...)
                        -D LKC_DIRECT_LINK
> 
> +HOST_OS := $(shell uname -o)
> +ifeq ($(HOST_OS),Cygwin)
> +HOSTLOADLIBES_mconf	= -lintl
> +HOSTLOADLIBES_conf	= -lintl
> +endif
> +
Hum, this test should be done if we detect nls support. See ifeq
($(KBUILD_HAVE_NLS),no) ...



> --- a/scripts/kconfig/lxdialog/check-lxdialog.sh
> +++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
>  <at>  <at>  -4,6 +4,10  <at>  <at>  # Check ncurses compatibility
>  # What library to link
>  ldflags()
>  {
> +	if [ "`uname -o`" == "Cygwin" ]; then
> +		echo '-lintl -lncurses'
> +		exit
> +	fi
You should test against libncurses.a and not hardcode it for cygwin...

Matthieu



