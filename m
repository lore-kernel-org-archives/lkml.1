Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbXFVGp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbXFVGp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 02:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXFVGpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 02:45:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:43473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbXFVGpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 02:45:15 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH for 2.6.22] [6/10] x86: Only make Macintosh drivers default on Macs
Date: Fri, 22 Jun 2007 08:45:07 +0200
User-Agent: KMail/1.9.6
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
References: <200706201223.443613000@suse.de> <20070621173628.GA21243@aepfle.de> <20070621175200.GA22507@aepfle.de>
In-Reply-To: <20070621175200.GA22507@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706220845.07573.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
> index 0852d33..dbe9626 100644
> --- a/drivers/macintosh/Kconfig
> +++ b/drivers/macintosh/Kconfig
> @@ -2,7 +2,7 @@
>  menuconfig MACINTOSH_DRIVERS
>  	bool "Macintosh device drivers"
>  	depends on PPC || MAC || X86
> -	default y if MAC
> +	default y if (PPC_PMAC || MAC)

Ah yes it needs to be PPC_MAC. Sigh. MAC apparently is only the m68k macs.
Patch is good, although I guess it would be better to change this death trap
and always define MAC on PPC MACs too.

-Andi
