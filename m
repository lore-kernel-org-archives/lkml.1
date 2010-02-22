Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0BVVWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:22:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60454 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754554Ab0BVVWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:22:16 -0500
Date: Mon, 22 Feb 2010 21:24:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
 writes" causes gobi_loader to hang
Message-ID: <20100222212458.69249775@lxorguk.ukuu.org.uk>
In-Reply-To: <201002222124.27777.anssi.hannula@iki.fi>
References: <Pine.LNX.4.44L0.1002221408200.1251-100000@iolanthe.rowland.org>
	<201002222124.27777.anssi.hannula@iki.fi>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, but does the tty interface guarantee that the data of one write call is 
> sent as one packet to the device?

Not usually but it can do. At least the core tty code supports this for
suitable ldiscs.

> If I understood this correctly, it seems the changes have caused it to now 
> concatenate short writes into one packet, which the device doesn't seem to 
> like.

If the device wants exactly bounded packets then for the firmware loader
tty is probably the wrong interface.
