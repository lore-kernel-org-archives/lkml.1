Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbZFRJML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbZFRJML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZFRJL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:11:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55260 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752172AbZFRJL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:11:57 -0400
Date: Thu, 18 Jun 2009 10:13:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 2/3] usb-serial: regression fix to move sysrq from hot
 path
Message-ID: <20090618101320.15c036a6@lxorguk.ukuu.org.uk>
In-Reply-To: <1245291609-14871-3-git-send-email-jason.wessel@windriver.com>
References: <1245291609-14871-1-git-send-email-jason.wessel@windriver.com>
	<1245291609-14871-2-git-send-email-jason.wessel@windriver.com>
	<1245291609-14871-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (port->console) {

	unlikely(port->console) I think is justified

> +		for (i = 0; i < urb->actual_length; i++, ch++) {
> +			if (!usb_serial_handle_sysrq_char(port, *ch))
> +				tty_insert_flip_char(tty, *ch, TTY_NORMAL);

But thats a minor twiddle so

Acked-by: Alan Cox <alan@linux.intel.com>

Alan
