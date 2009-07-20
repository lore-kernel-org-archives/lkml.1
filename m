Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZGTXcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZGTXcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZGTXcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:32:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47687 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753258AbZGTXcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:32:06 -0400
Date: Tue, 21 Jul 2009 00:32:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
       Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] [usb-serial] fix Ooops on uplug
Message-ID: <20090721003239.44ef8e9b@lxorguk.ukuu.org.uk>
In-Reply-To: <1248112313-7842-1-git-send-email-daniel@caiaq.de>
References: <20090720155502.50b84ae9@lxorguk.ukuu.org.uk>
	<1248112313-7842-1-git-send-email-daniel@caiaq.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 19:51:53 +0200
Daniel Mack <daniel@caiaq.de> wrote:

> When an USB serial adapter is disconnected and <Enter> is pressed on a
> connection still open on it (cu, minicom, ...), the kernel crashes.
> 
> The reason is that the serial port's resources are freed upon disconnect
> (in serial_hangup()) but the tty device layer is not made aware of that.
> Hence, the close callback will later access the resources again.

I don't think that is the case. The hangup terminates access to the
resources and replaces the file operations at tty level. The tty
level close called will be the close for the hung up tty ops not the usb
device ops.

hangup() is a termination of access to the bus resources for that tty
handle.

Alan
