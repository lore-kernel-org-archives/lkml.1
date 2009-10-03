Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZJCNHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZJCNHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 09:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZJCNHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 09:07:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43402 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756054AbZJCNHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 09:07:49 -0400
Date: Sat, 3 Oct 2009 14:09:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Johan Hovold <jhovold@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091003140902.38628d8a@lxorguk.ukuu.org.uk>
In-Reply-To: <m1ske1wgdi.fsf@fess.ebiederm.org>
References: <20090924154023.GA27480@localhost>
	<200909242103.48562.oliver@neukum.org>
	<20090924202107.4730f2af@lxorguk.ukuu.org.uk>
	<20090924211459.GB27963@localhost>
	<4ABD020B.4040901@gandalf.sssup.it>
	<20090929145514.GF2152@localhost>
	<20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
	<m163ayzevu.fsf@fess.ebiederm.org>
	<20091002084755.GA7382@localhost>
	<20091002173308.6158d734@lxorguk.ukuu.org.uk>
	<m1ske1wgdi.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Oct 2009 16:00:41 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> 
> I have seen a hang in:
>   /bin/stty (changing the baud rate)
>     set_termios
>       tty_wait_until_sent
>         tty_chars_in_buffer
>           ftdi_chars_in_buffer
> 
> Where the driver wedged for a serial port and no progress
> was made.
> 
> This happened to me several times with 2.6.31.  My initial
> hypothesis was this was a hardware error (as it only happened
> on single piece of hardware).  With all of the driver problems
> I suspect it could be a driver bug.

Driver bug I would think - or setup. If you've genuinely got the port
flow controlled then a request to set the termios after the I/O will wait
until a signal or carrier change (or indeed forever) quite correctly.
