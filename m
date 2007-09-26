Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbXIZQem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbXIZQem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXIZQef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:34:35 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34161 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbXIZQee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:34:34 -0400
Date: Wed, 26 Sep 2007 11:34:32 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Serge Hallyn <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] The config option itself
Message-ID: <20070926163432.GA23435@sergelap.austin.ibm.com>
References: <46FA7D4D.8040808@openvz.org> <46FA7E20.80207@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FA7E20.80207@openvz.org>
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
> namespaces are such.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 684ccfb..05a71d7 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -369,6 +360,23 @@ config RELAY
> 
>  	  If unsure, say N.
> 
> +config NAMESPACES
> +	bool "The namespaces support" if EMBEDDED
> +	default !EMBEDDED
> +	help
> +	  Provides the way to make tasks work with different objects using
> +	  the same id. For example same IPC id may refer to different objects
> +	  or same user id or pid may refer to different tasks when used in
> +	  different namespaces.
> +
> +config NAMESPACES_EXPERIMENTAL
> +	bool "Add the experimantal namespaces support" if EMBEDDED

Hi Pavel,

Overall this patchset looks good.

However the NAMESPACES_EXPERIMENTAL option should not have the
'if EMBEDDED', right?  This is about EXPERIMENTAL, not about
EMBEDDED, unlike the plain NAMESPACES option.

-serge

> +	depends on NAMESPACES && EXPERIMENTAL
> +	default !EMBEDDED
> +	help
> +	  Also include the support for the namespaces that are not fnished
> +	  or well developed yet
> +
>  config BLK_DEV_INITRD
>  	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
>  	depends on BROKEN || !FRV
