Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZFSH76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZFSH76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZFSH7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:59:50 -0400
Received: from n19.bullet.mail.mud.yahoo.com ([68.142.206.146]:26317 "HELO
	n19.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750884AbZFSH7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:59:50 -0400
X-Yahoo-Newman-Id: 414143.8739.bm@omp403.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wfQChZG6jiKpsJ7F6elrLFQszHVGX8LlzSsBupSKFMFN6MSRgk5/Q9W94sQZAHFXZxwk9Riiky0MNXFh7FSZT3Aa+Hf7H/qcyZZnXecQCmSKJFEYdpl5rohfSwF9/hJDWXNfghKj6NLvjiK+1aLpZ4IQ2DEN2gSqY6+6T6kdwCE=  ;
X-YMail-OSG: P2mw72wVM1nzsrKsrqKC.m6AzL.9HSlMXSGnnEHSEG0kLrjMBC_Gx47JcbU49g5orIliEjm6FWR.EB7hZGl6dkF6gX5oUyvE_HWR.Ah1K5oY7cHtVuKx.WICBZ2xLMdcMsw0UlhSUlVQOWyC1hM3G9I5TsnF8nPy0uHYE2D8JcROrOcD20xfPmmmGwSeugA8hu8xUpgIxpHydGtqvL44mzhr2u.ckC9v1Vzled7aUMEnRIlOa7CVKK6u8CSpe6FqgbAKfI1otSX98c6FNMwCSAWR8o8xkuAIY8GebwH7uk1AN7AJLJV3HbZQcZH3B57nypDF6Lckrrf2I_bK.Zdk3A--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 1/2 v2] at91/USB: Add USB drivers for at91sam9g45 series
Date: Fri, 19 Jun 2009 00:59:51 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, patrice.vilchez@atmel.com
References: <1244720355-10740-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1244720355-10740-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906190059.51576.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009, Nicolas Ferre wrote:
> Add both host and gadget USB drivers for at91sam9g45 series. Those SOC embed
> high speed USB interfaces.
> The gadget driver is the already available atmel_usba_udc.
> The host driver is an EHCI with its companion OHCI. EHCI is handled by the new
> ehci-atmel.c whereas the OHCI is always handled by ohci-at91.c. This last
> wrapper is modified to allow IRQ sharing between two controllers.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Talking only about the EHCI bits here ... it looks pretty generic
except for the clock management, which can't be.

The tricky bits here will be system suspend/resume support, with
the host controller able to trigger remote wakeup.  Clearly you
don't support system suspend/resume yet.

A slightly less tricky bit would be suspending the root hub.
Sometimes the hardware needs help there; other times it can
automatically gate the various clocks and save power.

If you split out patches for each of the drivers, I can ack
each of those seaprately.  And then hope to see patches which
add power management support before too long.

- Dave

