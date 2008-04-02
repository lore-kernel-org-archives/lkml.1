Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbYDBQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbYDBQ5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755789AbYDBQ5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:57:09 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:30918 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754910AbYDBQ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:57:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GM0pS3296qftPZjoGG6BWNJ8E9Ku/wUJi02tzdHEn9Octadguk7x6xogYx5RDgMhLH2Kri/IVPu4JyZzvcN57RGDqOY9OPdUt43sOdKEk8ZVFiFPa8u/s9LqqKLeu0bAYAJnlQMCcfTc5Rst7wb0u/Ly81Prw8nx7gJnOi7u4Rc=  ;
X-YMail-OSG: pf851g4VM1n9TKYM05eblbbh5A7EFfamWy7yDzWeT1sZYkSv8MYlkBx.04c9m5mab.3w5i.uEw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] usb ehci_iaa_watchdog fix
Date: Wed, 2 Apr 2008 09:56:59 -0700
User-Agent: KMail/1.9.6
Cc: stern@rowland.harvard.edu, pavel@suse.cz, oliver@neukum.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jikos@suse.cz,
       gregkh@suse.de, akpm@linux-foundation.org
References: <Pine.LNX.4.44L0.0804021106320.6272-100000@iolanthe.rowland.org> <20080402160414.25F3035F5F8@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <47F3B235.4000103@rtr.ca>
In-Reply-To: <47F3B235.4000103@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804020957.00494.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008, Mark Lord wrote:
> David Brownell wrote:
> >> Also, check out the thread on LKML started by Tino Keitel.  He had
> >> similar problems and found that reverting commit
> >> e82cc1288fa57857c6af8c57f3d07096d4bcd9d9 fixed them.
> > 
> > And try the change I suggested there:  taking the
> > HC_IS_RUNNING test out of ehci_iaa_watchdog().
> ..
> 
> Yup, that does indeed cure it.

Given your immediately-preceding experience, I'll wait for a
bit more confirmation ... but this seems like a candidate to
merge while 2.6.25 still hasn't frozen!!


> Here's a patch, in case you didn't already generate one:

I hadn't; thanks.

 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> 
> --- rc8/drivers/usb/host/ehci-hcd.c	2008-03-11 11:18:40.000000000 -0400
> +++ linux/drivers/usb/host/ehci-hcd.c	2008-04-02 12:16:40.000000000 -0400
> @@ -289,9 +289,7 @@
>  	 * (a) SMP races against real IAA firing and retriggering, and
>  	 * (b) clean HC shutdown, when IAA watchdog was pending.
>  	 */
> -	if (ehci->reclaim
> -			&& !timer_pending(&ehci->iaa_watchdog)
> -			&& HC_IS_RUNNING(ehci_to_hcd(ehci)->state)) {
> +	if (ehci->reclaim && !timer_pending(&ehci->iaa_watchdog)) {
>  		u32 cmd, status;
>  
>  		/* If we get here, IAA is *REALLY* late.  It's barely
> 


