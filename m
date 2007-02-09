Return-Path: <linux-kernel-owner+w=401wt.eu-S1946188AbXBIHz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946188AbXBIHz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 02:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946190AbXBIHz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 02:55:56 -0500
Received: from marvin.h-e-r-e-s-y.com ([87.106.62.5]:49948 "EHLO
	marvin.h-e-r-e-s-y.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946188AbXBIHzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 02:55:55 -0500
From: Andrew Walrond <andrew@walrond.org>
To: David Miller <davem@davemloft.net>
Subject: Re: Linux header change breaks linux-atm userspace build
Date: Fri, 9 Feb 2007 07:55:41 +0000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200702082131.25192.andrew@walrond.org> <20070208.160142.11599230.davem@davemloft.net>
In-Reply-To: <20070208.160142.11599230.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702090755.41932.andrew@walrond.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007 00:01, David Miller wrote:
> From: Andrew Walrond <andrew@walrond.org>
> Date: Thu, 8 Feb 2007 21:31:25 +0000
>
> > Sometime between 2.6.18.3 and 2.6.20, this change...
> >
> > --- /include/linux/atmarp.h     2007-01-10 16:32:05.000000000 +0000
> > +++ pkg/linux/include/linux/atmarp.h    2007-02-08 20:02:08.000000000
> > +0000 @@ -34,7 +34,7 @@
> >  struct atmarp_ctrl {
> >         enum atmarp_ctrl_type   type;   /* message type */
> >         int                     itf_num;/* interface number (if present)
> > */ -       uint32_t                ip;     /* IP address (act_need only)
> > */ +       __be32                  ip;     /* IP address (act_need only)
> > */ };
> >
> >  #endif
> >
> > was introduced, but __be32 is undefined, so atmarp.h should include
> > linux/types.h
>
> I'll fix this, thanks for reporting.

Actually, it seems that several other atm headers are also missing 
linux/types.h. I guess you can tell which ones have changed recently using 
git (I just patched linux-atm with liberal #include <linux/types.h>). But let 
me know if you want a full list.

Andrew Walrond
