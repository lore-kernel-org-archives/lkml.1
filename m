Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbZDAV77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbZDAV77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZDAV7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:59:48 -0400
Received: from baikonur.stro.at ([213.239.196.228]:38174 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZDAV7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:59:47 -0400
Date: Wed, 1 Apr 2009 23:41:41 +0200
From: maximilian attems <max@stro.at>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/5] deb-pkg: pass Debian maintainer script parameters
	to packaging hook scripts
Message-ID: <20090401214141.GB17518@stro.at>
References: <200904012133.37387.elendil@planet.nl> <200904012143.18562.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904012143.18562.elendil@planet.nl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Apr 2009, Frans Pop wrote:

> The Debian packaging scripts created by the deb-pkg target do not pass
> on the standard Debian maintainer script parameters to hook scripts,
> which means that those scripts cannot tell whether they are being called
> during e.g. install vs. upgrade, or removal vs. purge of the package.
> 
> As there are several variantions in how hook scripts are called from
> kernel packages, we pass the parameters in the environment variable
> DEB_MAINT_PARAMS rather than as extra arguments.
> 
> Bump version of builddep script to 1.3.
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>

ack for the env variable.
 
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index 5b1517d..c9a4dcd 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -1,6 +1,6 @@
>  #!/bin/sh
>  #
> -# builddeb 1.2
> +# builddeb 1.3
>  # Copyright 2003 Wichert Akkerman <wichert@wiggy.net>
>  #
>  # Simple script to generate a deb package for a Linux kernel. All the
> @@ -63,7 +63,11 @@ for script in postinst postrm preinst prerm ; do
>  
>  set -e
>  
> -test -d /etc/kernel/$script.d && run-parts --arg="$version" /etc/kernel/$script.d
> +# Pass maintainer script parameters to hook scripts
> +export DEB_MAINT_PARAMS="\$@"
> +
> +test -d $debhookdir/$script.d && \\
> +	run-parts --arg="$version" /etc/kernel/$script.d

gratious formating change, please if this needs to be broken in 2 lines,
break before && so that logic is more evident.
>  exit 0
>  EOF
>  	chmod 755 "$tmpdir/DEBIAN/$script"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
-- 
maks
