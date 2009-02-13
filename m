Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbZBMVDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbZBMVDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZBMVC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:02:59 -0500
Received: from kroah.org ([198.145.64.141]:58120 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752826AbZBMVC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:02:58 -0500
Date: Fri, 13 Feb 2009 11:09:53 -0800
From: Greg KH <greg@kroah.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth USB: fix kernel panic during suspend - 2.6.24
Message-ID: <20090213190953.GA958@kroah.com>
References: <1234518585.6647.26.camel@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234518585.6647.26.camel@ubuntu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 09:49:45AM +0000, Colin Ian King wrote:
> 
> The kernel panics when hci_usb_tx_complete() calls _urb_unlink()
> on an _urb which has been previously been removed from a list.
> This occurs during suspend while audio is being streamed to
> a bluetooth headset.
> 
> The panic occurs because hci_usb_suspend() dequeues _urb
> and then calls usb_kill_urb() - instead it should put _urb on
> the killed list first before killing the urb.
> 
> Also added a spin_lock around the list_add operation.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Is this still an issue on a supported-by-the-community kernel (.27, .28,
.29)?

thanks,

greg k-h
