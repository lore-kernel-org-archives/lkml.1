Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbXJ2R3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbXJ2R3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759618AbXJ2R2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:28:53 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60971 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758419AbXJ2R2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:28:52 -0400
Date: Mon, 29 Oct 2007 18:28:36 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Dirk Hohndel <hohndel@linux.intel.com>
cc: Jeff Garzik <jeff@garzik.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INPUT: fix hidinput_connect ignoring retval from
 input_register_device
In-Reply-To: <20071029152050.GA23411@bigserver.hohndel.org>
Message-ID: <Pine.LNX.4.64.0710291827140.18815@twin.jikos.cz>
References: <20071029152050.GA23411@bigserver.hohndel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Dirk Hohndel wrote:

> 	hidinput = kzalloc(sizeof(*hidinput), GFP_KERNEL);
> 	input_dev = input_allocate_device();
> 	if (!hidinput || !input_dev) {
> 		kfree(hidinput);
> 		input_free_device(input_dev);
> This either passes a NULL pointer to kfree or to input_free_device. That's
> not nice.

Actually both of the cases are fine -- it is valid to pass NULL pointer to 
kfree() and to input_free_device() too.

> Would something like this work?

Yes, I think that this patch is in principle fine, modulo the redundant 
NULL-ptr checks.

Thanks,

-- 
Jiri Kosina
