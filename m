Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbYBRUQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbYBRUQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761262AbYBRUQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:16:29 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:43337 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761251AbYBRUQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:16:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eNGWrGwPnsQnk4jdVW7rKzrcXpkDXLr0zav0ihyRDkMI4vdIR+HiLj6QdhI58o4LkiagAxTOn2ggQgwb8/C8taegd7WjvUYQqOB4kL2ESeN5pFmTImM6dQOcG6oCwdXHBAyIwARY/5AOlgesFKHj7qroAUdiBD0T82t5hn9i5fM=  ;
X-YMail-OSG: Sk1_YNQVM1mFhKYxvi6tRiDUEEE0vkWrjpl0juLuEeVvLzGbUMWrYCne2XkLFRnrJozKk5ubJg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: spi-devel-general@lists.sourceforge.net
Subject: Re: [spi-devel-general] atmel_spi clock polarity
Date: Mon, 18 Feb 2008 11:57:56 -0800
User-Agent: KMail/1.9.6
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, hskinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
References: <20080216.223252.25909396.anemo@mba.ocn.ne.jp> <20080218124237.0b5f701c@dhcp-252-066.norway.atmel.com> <20080218.231243.41197917.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080218.231243.41197917.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181157.57299.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008, Atsushi Nemoto wrote:
> 	 IIRC the clock state follows
> CSRn.CPOL just before the real transfer.

No ... clock state should be valid *before* chipselect goes
active.  So I'm thinking the patch from Haavard is likely
the right change.


> Like this (previous transfer 
> was MODE 0, new transfer is MODE 3):
> 
>            T0                T1 T2
> 
> CS      ~~~|________________________________________________

So at T0, some chip is selected (and never deselected) ...

> 
> CLK     ______________________|~|___|~~~|___|~~~|___|~~~|___

... and at T1 CPOL is changed??  That's wrong.  There should
never be a partial clock period while a chipselect is active.
While it's inactive, sure -- no chip should care.


> 
> SO      ~~~~~~~~~~~~~~~~~~~~~~~~~~|___|~~~|___|~~~|___|~~~|_
>                                    MSB
> 
> T0-T1 was relatively longer then T1-T2.  I suppose T1 is not the
> point of updating MR register, but the point of starting DMA transfer.
> 
