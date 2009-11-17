Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZKQSlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZKQSlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 13:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZKQSlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 13:41:31 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:45988 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbZKQSlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 13:41:31 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Date: Tue, 17 Nov 2009 19:41:34 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Johan Hovold <jhovold@gmail.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       linux-usb@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20090924154023.GA27480@localhost> <20091003140902.38628d8a@lxorguk.ukuu.org.uk> <m13a4df19g.fsf@fess.ebiederm.org>
In-Reply-To: <m13a4df19g.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911171941.34781.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 17. November 2009 19:35:07 schrieb Eric W. Biederman:
> Boiled down.  ftdi_chars_in_buffer is essentially
>  priv->tx_outstanding_bytes. tx_outstanding_bytes is incremented when an
>  urb request is sent and tx_outstanding_bytes is decremented when an urb
>  request completes.
> 
> It turns out I have a moderately noisy usb line, and so I occasionally
> get messages like:
> 
> ehci_hcd 0000:00:0a.1: detected XactErr len 0/7 retry 31
> 
> Which as best as I can tell result in the urb getting abandoned and
> neither completed nor canceled (because we have hit the maximum
> retry count and they still don't succeed).

The URB should be finished with an error code in urb->status.
ftdi_write_bulk_callback() does decrement the counter even in
the error case.

> Which appears to result in tx_outstanding_bytes getting stuck at
> some positive number.

Do you see this message

 	if (status) {
		dbg("nonzero write bulk status received: %d", status);
		return;
	}

if you enable debugging output?

	Regards
		Oliver

