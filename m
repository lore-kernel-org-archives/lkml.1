Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbYCEXrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbYCEXrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757808AbYCEXrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:47:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43528 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559AbYCEXrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:47:07 -0500
Date: Wed, 5 Mar 2008 15:46:53 -0800
From: Greg KH <greg@kroah.com>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Subject: Re: Behaviour of device_register
Message-ID: <20080305234653.GA5904@kroah.com>
References: <8b67d60803051525g3aca775dmc14d1c2450b34168@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60803051525g3aca775dmc14d1c2450b34168@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 11:25:48PM +0000, Adrian McMenamin wrote:
> The observed behaviour for me is that it appears to be blocking the
> vblank interrupt on my box (or more accurately stopping the workqueue
> that the interrupt handler calls from running). And without the vblank
> my bus won't process dma and so therefore the attempt to register the
> device in question fails.
> 
> But I can see no reason from a glance over the code why that (vblanks
> being blocked) would be the case - have I missed something and the
> vblanks will be blocked, or should I be looking elsewhere for the root
> cause of this problem?

device_register(), on it's own, does not touch any hardware, nor prevent
anything else in the kernel from happening.

So I think you need to look elsewhere, like into the bus that is doing
the device_register() call :)

good luck,

greg k-h
