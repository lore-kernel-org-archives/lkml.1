Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYFAOnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYFAOnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbYFAOnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:43:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38602 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYFAOnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:43:16 -0400
Date: Sun, 1 Jun 2008 15:42:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Eric BENARD <ebenard@free.fr>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 4/7] mmc: at91_mci: add multiwrite switch
Message-ID: <20080601144251.GS5818@flint.arm.linux.org.uk>
References: <483FE9E7.7020707@atmel.com> <483FEE58.5000500@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <483FEE58.5000500@atmel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 02:08:56PM +0200, Nicolas Ferre wrote:
> at91_mci is capable of multiwrite. Enable it before it disappears.

This doesn't look safe.  MULTIWRITE is not about whether you can do
multi-writes, but whether you can properly report how many bytes were
successfully written to the card _and_ the card acknowledged as having
been successfully written.

It looks to me as if the AT91 MMC driver reports no bytes, or all
bytes if the FIFO reports that it became empty, which presumably it
may do if you're unable to keep the FIFO full?

(Dropped Hans-JA¼rgen from the CC list since my mailer seems to corrupt
the address.)

If Pierre wants to remove the MULTIWRITE flag, I'd like to hear his
solution for the pxamci driver, where the only way to ascertain how
many bytes were transmitted may be to walk the SG list comparing the
DMA pointer with what was in the hardware DMA engine at the time.
Maybe.
