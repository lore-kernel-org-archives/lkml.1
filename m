Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZFRJKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZFRJKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZFRJKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:10:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55254 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752172AbZFRJKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:10:10 -0400
Date: Thu, 18 Jun 2009 10:11:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] usb,console: Fix regression in usb console on
 kernel boot
Message-ID: <20090618101130.2bc3cae8@lxorguk.ukuu.org.uk>
In-Reply-To: <1245291609-14871-2-git-send-email-jason.wessel@windriver.com>
References: <1245291609-14871-1-git-send-email-jason.wessel@windriver.com>
	<1245291609-14871-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 21:20:07 -0500
Jason Wessel <jason.wessel@windriver.com> wrote:

> The commit 335f8514f200e63d689113d29cb7253a5c282967 introduced a
> regression which stopped usb consoles from working correctly as a
> kernel boot console as well as interactive login device.
> 
> The addition of the serial_close() which in turn calls
> tty_port_close_start() will change the reference count of port.count
> and warn about it.  The usb console code had previously incremented
> the port.count to indicate it was making use of the device as a
> console and the forced change causes a double open on the usb device
> which leads to a non obvious kernel oops later on when the tty is
> freed.
> 
> To fix the problem instead make use of port->console to track if the
> port is in fact an active console port to avoid double initialization
> of the usb serial device.  The port.count is incremented and
> decremented only with in the scope of usb_console_setup() for the
> purpose of the low level driver initialization.

Acked-by: Alan Cox <alan@linux.intel.com>
