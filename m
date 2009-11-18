Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbZKRD4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbZKRD4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 22:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbZKRD4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 22:56:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:34197 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbZKRD4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 22:56:04 -0500
Date: Tue, 17 Nov 2009 19:44:01 -0800
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Johan Hovold <jhovold@gmail.com>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] ftdi_sio:  Keep going when write errors are
 encountered.
Message-ID: <20091118034401.GA17349@suse.de>
References: <20090924154023.GA27480@localhost>
 <20091003140902.38628d8a@lxorguk.ukuu.org.uk>
 <m13a4df19g.fsf@fess.ebiederm.org>
 <200911171941.34781.oliver@neukum.org>
 <m1lji4od0k.fsf@fess.ebiederm.org>
 <m1fx8co7d3.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fx8co7d3.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 07:10:48PM -0800, Eric W. Biederman wrote:
> 
> The use of urb->actual_length to update tx_outstanding_bytes
> implicitly assumes that the number of bytes actually written is the
> same as the number of bytes we tried to write.  On error that
> assumption is violated so just use transfer_buffer_length the number
> of bytes we intended to write to the device.
> 
> If an error occurs we need to fall through and call
> usb_serial_port_softint to wake up processes waiting in
> tty_wait_until_sent.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Nice job, thanks for debugging this.  I'll go queue it up.

greg k-h
