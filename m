Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbXJ1Opo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbXJ1Opo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 10:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbXJ1Oph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 10:45:37 -0400
Received: from styx.suse.cz ([82.119.242.94]:52217 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751240AbXJ1Opg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 10:45:36 -0400
Date: Sun, 28 Oct 2007 15:45:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbserial: fix inconsistent lock state
In-Reply-To: <20071028122416.GA11679@gollum.tnic>
Message-ID: <Pine.LNX.4.64.0710281543260.12935@jikos.suse.cz>
References: <20071028122416.GA11679@gollum.tnic>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Borislav Petkov wrote:

> ---
> In commit acd2a847e7fee7df11817f67dba75a2802793e5d usb_serial_generic_write()
> disables interrupts when taking &port->lock which is also taken in
> usb_serial_generic_read_bulk_callback() resulting in an inconsistent lock state
> due to the latter not disabling interrupts on the local cpu. Fix that by
> disabling interrupts in the latter call site also.
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

You are right, I missed the usb_serial_generic_read_bulk_callback() one, 
thanks for catching this.

	Acked-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
SUSE Labs
