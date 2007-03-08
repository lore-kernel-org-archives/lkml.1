Return-Path: <linux-kernel-owner+w=401wt.eu-S2992812AbXCHAcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992812AbXCHAcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992814AbXCHAcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:32:33 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:50217 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992812AbXCHAcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:32:32 -0500
Date: Wed, 7 Mar 2007 16:28:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?ISO-8859-1?Q? "J.A._Magall=F3n" ?= <jamagallon@ono.com>,
       linux-kernel@vger.kernel.org, Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: e1000 oops on boot [Re: 2.6.21-rc2-mm2]
Message-Id: <20070307162853.0337e643.randy.dunlap@oracle.com>
In-Reply-To: <20070307162315.76f2a60b.akpm@linux-foundation.org>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	<20070308010323.58b80d96@werewolf-wl>
	<20070307162315.76f2a60b.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 16:23:15 -0800 Andrew Morton wrote:

> The below will apppear in -rc3-mm1 (hopefully later today) and it will
> hopefully fix that crash.
> 
> 
> From: Auke Kok <auke-jan.h.kok@intel.com>
> 
> ---
> 
>  drivers/net/e1000/e1000_main.c |   66 +++++++++++++++++++++----------
>  1 files changed, 45 insertions(+), 21 deletions(-)
> 
> diff -puN drivers/net/e1000/e1000_main.c~e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq drivers/net/e1000/e1000_main.c
> --- a/drivers/net/e1000/e1000_main.c~e1000-fix-be-ready-for-incoming-irq-at-pci_request_irq
> +++ a/drivers/net/e1000/e1000_main.c
> @@ -522,14 +522,15 @@ e1000_release_manageability(struct e1000
>  	}
>  }

Auke:

Below, please s/@adapter =/@adapter:/ to make it be correct
kernel-doc notation.

> -int
> -e1000_up(struct e1000_adapter *adapter)
> +/**
> + * e1000_configure - configure the hardware for RX and TX
> + * @adapter = private board structure
> + **/
> +static void e1000_configure(struct e1000_adapter *adapter)
>  {


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
