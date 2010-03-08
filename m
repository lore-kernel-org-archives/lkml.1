Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0CHRg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 12:36:58 -0500
Received: from ppp173-197.broadband.gorge.net ([209.216.173.197]:38628 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753922Ab0CHRgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 12:36:52 -0500
Date: Mon, 8 Mar 2010 17:35:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
       Alan Cox <alan@linux.intel.com>, Daniel Mack <daniel@caiaq.de>,
       "Mark J. Adamson" <mark.adamson@ftdichip.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Fix locking for change_speed() function
Message-ID: <20100308173548.3c414cb5@lxorguk.ukuu.org.uk>
In-Reply-To: <1268053803-7666-1-git-send-email-abogani@texware.it>
References: <1268053803-7666-1-git-send-email-abogani@texware.it>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.7; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  8 Mar 2010 14:10:03 +0100
Alessio Igor Bogani <abogani@texware.it> wrote:

> The change_speed() function set the baudrate of the device: so this function
> should be serialized against multiple calls. Use the cfg_lock mutex to do this.

Should be ok anyway the set_termios callback occurs under the tty termios
lock, and will not occur in parallel with an initial open or final close.

Alan
