Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbXI0M2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbXI0M2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbXI0M2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:28:43 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33200 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbXI0M2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:28:42 -0400
Message-ID: <46FBA1EF.7010909@fr.ibm.com>
Date: Thu, 27 Sep 2007 14:28:31 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@osdl.org>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] The config option itself
References: <46FA7D4D.8040808@openvz.org> <46FA7E20.80207@openvz.org>
In-Reply-To: <46FA7E20.80207@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
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

Acked-by: Cedric Le Goater <clg@fr.ibm.com>

Thanks !

C. 
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
> +	depends on NAMESPACES && EXPERIMENTAL
> +	default !EMBEDDED
> +	help
> +	  Also include the support for the namespaces that are not fnished
> +	  or well developed yet
> +
>  config BLK_DEV_INITRD
>  	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
>  	depends on BROKEN || !FRV
> 

