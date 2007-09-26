Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbXIZQcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbXIZQcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXIZQcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:32:01 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10326 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbXIZQcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:32:00 -0400
Date: Wed, 26 Sep 2007 09:30:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Serge Hallyn <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] The config option itself
Message-Id: <20070926093028.c3a57137.randy.dunlap@oracle.com>
In-Reply-To: <46FA7E20.80207@openvz.org>
References: <46FA7D4D.8040808@openvz.org>
	<46FA7E20.80207@openvz.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 19:43:28 +0400 Pavel Emelyanov wrote:

> The option is called NAMESPACES. It can be selectable only
> if EMBEDDED is chosen (this was Eric's requisition). When
> the EMBEDDED is off namespaces will be on automatically.

and when EMBEDDED is on, namespaces will be off automatically,
until it is enabled?  Is that what you want?  (It's OK by me.)

Same way for NAMESPACES_EXPERIMENTAL.

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

	bool "Namespaces support" if EMBEDDED

> +	default !EMBEDDED
> +	help
> +	  Provides the way to make tasks work with different objects using
> +	  the same id. For example same IPC id may refer to different objects
> +	  or same user id or pid may refer to different tasks when used in
> +	  different namespaces.
> +
> +config NAMESPACES_EXPERIMENTAL
> +	bool "Add the experimantal namespaces support" if EMBEDDED

	              experimental

> +	depends on NAMESPACES && EXPERIMENTAL
> +	default !EMBEDDED
> +	help
> +	  Also include the support for the namespaces that are not fnished
> +	  or well developed yet
> +
>  config BLK_DEV_INITRD
>  	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
>  	depends on BROKEN || !FRV
> -


---
~Randy
Phaedrus says that Quality is about caring.
