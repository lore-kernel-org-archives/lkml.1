Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbYGVTxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbYGVTxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYGVTxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:53:03 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63223 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYGVTxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:53:01 -0400
Date: Tue, 22 Jul 2008 12:52:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: linux-next build error (PNP/IXJ)
Message-Id: <20080722125241.8fb696b1.randy.dunlap@oracle.com>
In-Reply-To: <200807221157.14371.bjorn.helgaas@hp.com>
References: <20080722102739.61462b04.randy.dunlap@oracle.com>
	<200807221157.14371.bjorn.helgaas@hp.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 11:57:13 -0600 Bjorn Helgaas wrote:

> On Tuesday 22 July 2008 11:27:39 am Randy Dunlap wrote:
> > I'm seeing several build errors in linux-next-20080722 that I haven't
> > seen previously, although I don't know what changed to cause this.
> > 
> > They are all basically the same, in ixj (drivers/telephony/ixj*), when
> > CONFIG_PNP=n, and CONFIG_PHONE_IXJ=y or =m (so the actual error message
> > varies depending on IXJ=y or =m):
> > 
> > IXJ=y:
> > ixj.c:(.text+0x329d98): undefined reference to `pnp_get_resource'
> > or IXJ=m:
> > ERROR: "pnp_get_resource" [drivers/telephony/ixj.ko] undefined!
> > 
> > 
> > Suggestions?
> 
> I'd use something like the attached.  I don't have a build environment
> where CONFIG_PNP=n (all I have is x86 and ia64), so I haven't tested
> this.
> 
> ixj: don't use PNP interfaces when CONFIG_PNP=n
>     
> This patch fixes a build problem when CONFIG_PNP=n.
>     
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
> index 49cd979..51b7fb4 100644
> --- a/drivers/telephony/ixj.c
> +++ b/drivers/telephony/ixj.c
> @@ -7588,6 +7588,7 @@ static IXJ *new_ixj(unsigned long port)
>  
>  static int __init ixj_probe_isapnp(int *cnt)
>  {               
> +#ifdef CONFIG_PNP
>  	int probe = 0;
>  	int func = 0x110;
>          struct pnp_dev *dev = NULL, *old_dev = NULL;
> @@ -7664,6 +7665,9 @@ static int __init ixj_probe_isapnp(int *cnt)
>  		dev = NULL;
>  	}
>  	return probe;
> +#else
> +	return 0;
> +#endif
>  }
>                          
>  static int __init ixj_probe_isa(int *cnt)
> --

Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
