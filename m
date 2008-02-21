Return-Path: <linux-kernel-owner+w=401wt.eu-S1763363AbYBUTkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763363AbYBUTkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYBUTki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:40:38 -0500
Received: from gw.goop.org ([64.81.55.164]:53058 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbYBUTkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:40:36 -0500
Message-ID: <47BDD32A.6030201@goop.org>
Date: Thu, 21 Feb 2008 11:38:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: yamahata@valinux.co.jp
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, linux-ia64@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       "Stephen C. Tweedie" <sct@redhat.com>
Subject: Re: [PATCH 06/11] xen: move arch/x86/xen/events.c undedr drivers/xen
 and split out arch specific part.
References: <20080221084530.470680000@ls.local.valinux.co.jp> <20080221091002.222498000@ls.local.valinux.co.jp>
In-Reply-To: <20080221091002.222498000@ls.local.valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yamahata@valinux.co.jp wrote:
> diff --git a/arch/x86/xen/events.c b/drivers/xen/events.c
> similarity index 95%
> rename from arch/x86/xen/events.c
> rename to drivers/xen/events.c
> index dcf613e..7474739 100644
> --- a/arch/x86/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -37,7 +37,9 @@
>  #include <xen/interface/xen.h>
>  #include <xen/interface/event_channel.h>
>  
> -#include "xen-ops.h"
> +#ifdef CONFIG_X86
> +# include "../arch/x86/xen/xen-ops.h"
> +#endif

Hm.  Perhaps it would be better to move whatever definition you need 
into a header in a common place (or move xen-ops.h entirely).

    J
