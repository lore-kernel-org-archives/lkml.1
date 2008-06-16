Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbYFPN2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbYFPN2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbYFPN2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:28:08 -0400
Received: from ozlabs.org ([203.10.76.45]:35004 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358AbYFPN2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:28:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sean Young <sean@mess.org>
Subject: Re: Regression: boot failure on AMD Elan TS-5500
Date: Mon, 16 Jun 2008 23:27:34 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Anvin" <hpa@zytor.com>
References: <20080616121138.GA51097@atlantis.8hz.com>
In-Reply-To: <20080616121138.GA51097@atlantis.8hz.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806162327.34912.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 June 2008 22:11:39 Sean Young wrote:
> The symptons are either a crash or reboot on booting the kernel. No
> printk's have occurred yet -- even with early printk on.
>
> 2.6.15 worked on this board however current does not. I've bisected it to:
>
> 	commit a24e785111a32ccb7cebafd24b1b1cb474ea8e5d
> 	Author: Rusty Russell <rusty@rustcorp.com.au>
> 	Date:   Sun Oct 21 16:41:35 2007 -0700
>
> 	    i386: paravirt boot sequence

Hi Sean,

   Thanks for tracking this down.  Can we try reverting this in pieces to see 
exactly what the cause was?

1) Revert arch/x86/boot/compressed/head_32.S
2) If that doesn't fix it, Try removing the 8 lines which were added to 
arch/x86/kernel/head_32.S

I assume this is CONFIG_PARAVIRT=n?

Thanks,
Rusty.
