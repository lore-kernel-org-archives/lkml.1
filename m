Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbXJAPx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbXJAPx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbXJAPxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:53:20 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33122 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbXJAPxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:53:19 -0400
Date: Mon, 1 Oct 2007 10:53:17 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Cedric Le Goater <clg@fr.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH 1/5] The config option itself
Message-ID: <20071001155317.GB26322@sergelap.austin.ibm.com>
References: <470112C7.8000803@openvz.org> <47011347.70906@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47011347.70906@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> The option is called NAMESPACES. It can be selectable only
> if EMBEDDED is chosen (this was Eric's requisition). When
> the EMBEDDED is off namespaces will be on automatically.
> 
> One more option (NAMESPACES_EXPERIMENTAL) was added by 
> Serge's request to move there all the namespaces that are 
> not finished yet. Currently only the user and the network
> namespaces are such. This option is selectable all the
> time NAMESPACES are "y" regardless of EMBEDDED one.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> Acked-by: Cedric Le Goater <clg@fr.ibm.com>

Looks good.  Thanks.

Acked-by: Serge Hallyn <serue@us.ibm.com>

(for the whole set, just to save the list from a few emails)

-serge

> 
> ---
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 6bb603a..67b1e41 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -390,6 +381,23 @@ config RELAY
> 
>  	  If unsure, say N.
> 
> +config NAMESPACES
> +	bool "Namespaces support" if EMBEDDED
> +	default !EMBEDDED
> +	help
> +	  Provides the way to make tasks work with different objects using
> +	  the same id. For example same IPC id may refer to different objects
> +	  or same user id or pid may refer to different tasks when used in
> +	  different namespaces.
> +
> +config NAMESPACES_EXPERIMENTAL
> +	bool "Add experimantal namespaces support"
> +	depends on NAMESPACES && EXPERIMENTAL
> +	default n
> +	help
> +	  Also include the support for the namespaces that are not fnished
> +	  or well developed yet
> +
>  config BLK_DEV_INITRD
>  	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
>  	depends on BROKEN || !FRV
