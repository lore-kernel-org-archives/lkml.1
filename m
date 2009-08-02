Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZHBRSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZHBRSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 13:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZHBRSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 13:18:34 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:36596 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZHBRSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 13:18:33 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alex Riesen <raa.lkml@gmail.com>
Subject: Re: Oops in CDC ACM after an Openmoko phone (neo1973) changes its usb interface from ACM to Ethernet
Date: Sun, 2 Aug 2009 19:19:10 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.name>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <81b0412b0908020940l3fcb2c2ds184fa87df82b5730@mail.gmail.com>
In-Reply-To: <81b0412b0908020940l3fcb2c2ds184fa87df82b5730@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908021919.11169.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 2. August 2009 18:40:56 schrieb Alex Riesen:
> [   75.453444] Call Trace:
> [   75.453444]  [<ffffffff812a77b2>] usb_autopm_get_interface+0xe/0x10
> [   75.453444]  [<ffffffffa0072e19>] acm_port_down+0x3f/0x1bb [cdc_acm]
> [   75.453444]  [<ffffffff811f0af1>] ? tty_port_close_start+0xc1/0x153
> [   75.453444]  [<ffffffffa0073258>] acm_tty_close+0x3d/0x83 [cdc_acm]
> [   75.453444]  [<ffffffff811eaca7>] tty_release_dev+0x1bf/0x4e8
> [   75.453444]  [<ffffffffa00732c3>] ? acm_tty_open+0x25/0x2ae [cdc_acm]

This can happen only if acm_port_down() fails to detect that the device has
been disconnected, as it calls usb_autopm_get_interface()
only if acm->dev != NULL.
This however should not happen if acm_disconnect runs.

Can you put a printk into acm_disconnect and recompile with CONFIG_USB_DEBUG?

	Regards
		Oliver

