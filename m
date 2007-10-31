Return-Path: <linux-kernel-owner+w=401wt.eu-S1759423AbXJaQW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423AbXJaQW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbXJaQWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:22:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25525 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbXJaQWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:22:21 -0400
Date: Wed, 31 Oct 2007 09:19:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] The config option itself
Message-Id: <20071031091906.dd84761a.randy.dunlap@oracle.com>
In-Reply-To: <4728615D.5070700@openvz.org>
References: <47285FEE.9030001@openvz.org>
	<4728615D.5070700@openvz.org>
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

On Wed, 31 Oct 2007 14:05:01 +0300 Pavel Emelyanov wrote:

> The option is called NAMESPACES. It can be selectable only
> if EMBEDDED is chosen (this was Eric's requisition). When
> the EMBEDDED is off namespaces will be on automatically.
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>


and when EMBEDDED is on, it looks like NAMESPACES will be off
automatically (but user-changeable)?  Is that intended?


> ---
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index c3de3ed..fc76773 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -400,6 +400,15 @@ config RELAY
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
>  config BLK_DEV_INITRD
>  	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
>  	depends on BROKEN || !FRV


---
~Randy
