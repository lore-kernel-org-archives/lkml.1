Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbYCMU2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbYCMU2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYCMU1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:27:55 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:43588 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752221AbYCMU1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:27:54 -0400
Date: Thu, 13 Mar 2008 21:28:20 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] macb: Basic suspend/resume support
Message-ID: <20080313212820.67840cb4@siona.local>
In-Reply-To: <200803131318.56769.david-b@pacbell.net>
References: <1205419185-26395-7-git-send-email-hskinnemoen@atmel.com>
	<1205419185-26395-8-git-send-email-hskinnemoen@atmel.com>
	<200803131318.56769.david-b@pacbell.net>
Organization: Atmel
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2008 20:27:38.0972 (UTC) FILETIME=[AE5FE9C0:01C88548]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 12:18:56 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Thursday 13 March 2008, Haavard Skinnemoen wrote:
> > ---
> >  drivers/net/macb.c |   37 +++++++++++++++++++++++++++++++++++++
> >  1 files changed, 37 insertions(+), 0 deletions(-)  
> 
> Shouldn't this look more like the suspend/resume support
> in drivers/net/arm/at91_ether.c ?  I don't see calls to
> netif_stop_queue()/netif_start_queue(), among other things.

Could be, although netif_stop_queue()/netif_start_queue() is done by
netif_device_detach() and netif_device_attach() respectively.

We should probably shut things down gracefully as well...not nice to
disable the clock when the MAC is in the middle of transmitting a
frame. Like I said in the introductory mail, this patch is just a quick
hack to prevent the macb from waking the system prematurely.

> The fact that this driver leaves the peripheral clocked
> when it's not open is a minor PM goof; ditto not using
> the PHY irq to track connect/disconnect.  But that's just
> general PM stuff, not specific to suspend/resume support.

Right, it's on my todo list.

Haavard
