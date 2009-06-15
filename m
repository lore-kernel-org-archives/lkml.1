Return-Path: <linux-kernel-owner+w=401wt.eu-S1761976AbZFOPuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976AbZFOPuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZFOPuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:50:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55814 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751814AbZFOPuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:50:08 -0400
Date: Mon, 15 Jun 2009 16:51:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ldisc: propagate errors from tty_ldisc_release
Message-ID: <20090615165126.1ecdff09@lxorguk.ukuu.org.uk>
In-Reply-To: <20090615153925.GA27696@damson.getinternet.no>
References: <20090615153925.GA27696@damson.getinternet.no>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH] tty_ldisc: propagate errors from tty_ldisc_release
> 
> This is probably better than just ignoring the errors.

tty_ldisc_halt doesn't return an error as such - it just reports whether
the work could be cancelled. Nor can we exit on error paths in those
situations.

Basically one or two cases need to know if we cancelled the work queue or
not (so they can restart it).

So NAK the patch
