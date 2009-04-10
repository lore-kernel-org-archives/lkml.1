Return-Path: <linux-kernel-owner+w=401wt.eu-S1763750AbZDJVvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763750AbZDJVvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 17:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZDJVvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 17:51:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865AbZDJVvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 17:51:43 -0400
Date: Fri, 10 Apr 2009 14:47:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jeff Haran" <jharan@Brocade.COM>
Cc: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
       Kumar Gala <galak@kernel.crashing.org>, Dave Jiang <djiang@mvista.com>,
       linuxppc-dev@ozlabs.org
Subject: Re: bug in drivers/edac/mpc85xx_edac.c:mpc85xx_mc_check() ?
Message-Id: <20090410144715.0fa5939e.akpm@linux-foundation.org>
In-Reply-To: <57AC2FA1761300418C7AB8F3EA493C9702C5F200@HQ-EXCH-5.corp.brocade.com>
References: <57AC2FA1761300418C7AB8F3EA493C9702C5F200@HQ-EXCH-5.corp.brocade.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Wed, 8 Apr 2009 14:57:42 -0700
"Jeff Haran" <jharan@Brocade.COM> wrote:

> Hi,
> 
> Recent versions of this function start off with:
> 
> static void mpc85xx_mc_check(struct mem_ctl_info *mci)
> {
>     struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
>     ...
> 
>     err_detect = in_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT);
>     if (err_detect)
>         return;
> 
>     ...
> }
> 
> My reading of the Freescale 8548E Manual leads me to conclude that the
> Memory Error Detect register (ERR_DETECT) will have various bits set if
> the memory controller has detected an error since the last time it was
> cleared. If no memory error has occurred, the register will contain 0.
> 
> Perhaps I am missing something very basic, but it seem to me that the
> above "if" should be:
> 
>     if (!err_detect)
>         return;
> 
> as the existing code would seem to read "if any errors have occurred,
> ignore them", though perhaps testing has demonstrated that the Freescale
> manual is in error.
> 
> Please include this email address in responses as I do not subscribe.
> 
> Thanks,
> 
> Jeff Haran
> Brocade

