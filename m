Return-Path: <linux-kernel-owner+w=401wt.eu-S964898AbZGQRUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898AbZGQRUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 13:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934732AbZGQRUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 13:20:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41670 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933550AbZGQRUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 13:20:01 -0400
Date: Fri, 17 Jul 2009 18:18:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Harris, Jeff" <Jeff_Harris@kentrox.com>
Cc: <alan@linux.intel.com>, <vapier@gentoo.org>, <adobriyan@gmail.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: Fix tcdrain hang due to tty chars_in_buffer errors
Message-ID: <20090717181852.54b1e41f@lxorguk.ukuu.org.uk>
In-Reply-To: <2E93DD7A4E576E48956F4A861E8B2CB801137D6D@dubexchange.corp.kentrox.com>
References: <1247843274-7462-1-git-send-email-jeff_harris@kentrox.com>
	<20090717170124.05881456@lxorguk.ukuu.org.uk>
	<2E93DD7A4E576E48956F4A861E8B2CB801137D6D@dubexchange.corp.kentrox.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009 12:36:22 -0400
"Harris, Jeff" <Jeff_Harris@kentrox.com> wrote:

> That was my other thought, but there are other kernel drivers which do
> report errors from chars_in_buffer.  A grep of the code shows
> ipw_chars_in_buffer in drivers/char/pcmcia/ipwireless/tty.c,
> hvc_chars_in_buffer in hvc_console.c, ntty_chars_in_buffer in nozomi.c,
> if_chars_in_buffer in isdn/gigaset/interface.c, etc.  Do they all need
> to be updated?  

Yes I've squashed a pile and there may be more left.

> Should the return type be unsigned int to make the behavior more
> explicit?  The signed type may be interpreted along the lines of a read
> or write call which returns a count or a negative value to indicate a
> failure.

That would simply have people returning very large numbers. I don't think
the compiler can cure that. Putting a WARN_ON(x < 0); might liven it up
though.

Alan
