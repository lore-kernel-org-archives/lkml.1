Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0BAMwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:52:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab0BAMwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:52:03 -0500
Message-ID: <4B66CE72.1020003@suse.cz>
Date: Mon, 01 Feb 2010 13:52:02 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: John Saalwaechter <saalwaechter@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts: use %_tmppath in "make rpm-pkg"
References: <506c8f0b1001311618i3b8f72c5w9321e3ef26413a20@mail.gmail.com>
In-Reply-To: <506c8f0b1001311618i3b8f72c5w9321e3ef26413a20@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1.2.2010 01:18, John Saalwaechter wrote:
> The mkspec script hardcodes "/var/tmp" into the generated rpm spec file's
> BuildRoot. The user, however, may have a custom setting for %_tmppath,
> which should be used in BuildRoot.  This patch changes mkspec's
> BuildRoot output to appropriately use %_tmppath.

Thanks, applied. Please CC linux-kbuild@ on changes like this.

Michal


> Signed-off-by: John Saalwaechter <saalwaechter@gmail.com>
> ---
> diff -uprN a/scripts/package/mkspec b/scripts/package/mkspec
> --- a/scripts/package/mkspec    2010-01-28 15:06:20.000000000 -0800
> +++ b/scripts/package/mkspec    2010-01-31 15:46:23.815300460 -0800
> @@ -39,7 +39,7 @@ if ! $PREBUILT; then
>  echo "Source: kernel-$__KERNELRELEASE.tar.gz"
>  fi
> 
> -echo "BuildRoot: /var/tmp/%{name}-%{PACKAGE_VERSION}-root"
> +echo "BuildRoot: %{_tmppath}/%{name}-%{PACKAGE_VERSION}-root"
>  echo "Provides: $PROVIDES"
>  echo "%define __spec_install_post /usr/lib/rpm/brp-compress || :"
>  echo "%define debug_package %{nil}"

