Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbZGIVtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbZGIVtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbZGIVtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:49:33 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:47771 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbZGIVtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:49:32 -0400
Date: Thu, 9 Jul 2009 17:49:08 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: maximilian attems <max@stro.at>
Cc: linux-kbuild@vger.kernel.org, sam@ravnborg.org,
       maximilian attems <max@stro.at>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: deb-pkg fix install scripts for posix sh
Message-ID: <20090709174908.40e8031c@mycelium.queued.net>
In-Reply-To: <1246817854-27396-1-git-send-email-max@stro.at>
References: <1246817854-27396-1-git-send-email-max@stro.at>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  5 Jul 2009 20:17:34 +0200
maximilian attems <max@stro.at> wrote:

> bash versus dash and posh disagree on expanding $@ within double
> quotes: export x="$@"
> see http://bugs.debian.org/381091 for details
> just use the arglist with $*.
> 
> dpkg: error processing linux-image-2.6.31-rc1_2.6.31-rc1-18_i386.deb
> (--install): subprocess pre-installation script returned error exit
> status 2 export: 6: 2.6.31-rc1-18: bad variable name
> fixes http://bugzilla.kernel.org/show_bug.cgi?id=13567
> 
> seen on Ubuntu as there dash is the default sh,
> versus bash on Debian.
> 

Acked-By: Andres Salomon <dilinger@collabora.co.uk>

This should be applied ASAP, as it breaks things for every
ubuntu user who attempts to use 'make deb-pkg'.


> Reported-by: Pauli <suokkos@gmail.com>
> Cc: Frans Pop <elendil@planet.nl>
> Cc: Andres Salomon <dilinger@debian.org>
> Signed-off-by: maximilian attems <max@stro.at>
> ---
>  scripts/package/builddeb |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index b19f1f4..8b357b0 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -89,7 +89,7 @@ for script in postinst postrm preinst prerm ; do
>  set -e
>  
>  # Pass maintainer script parameters to hook scripts
> -export DEB_MAINT_PARAMS="\$@"
> +export DEB_MAINT_PARAMS="\$*"
>  
>  test -d $debhookdir/$script.d && run-parts --arg="$version"
> $debhookdir/$script.d exit 0
