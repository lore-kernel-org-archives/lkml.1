Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYG3XIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYG3XIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYG3XIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:08:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34807 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752039AbYG3XIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:08:46 -0400
Date: Wed, 30 Jul 2008 23:51:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eugeniy Meshcheryakov <eugen@debian.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] try harder to load tty ldisc driver
Message-ID: <20080730235130.32d36046@lxorguk.ukuu.org.uk>
In-Reply-To: <20080729204512.GA6242@localhost.localdomain>
References: <20080729204512.GA6242@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 22:45:12 +0200
Eugeniy Meshcheryakov <eugen@debian.org> wrote:

> Currently function tty_ldisc_get() tries to load an ldisc driver module
> only when tty_ldisc_try_get() returns -EAGAIN. This happens only if
> module is being unloaded. If ldisc module is not loaded
> tty_ldisc_try_get() returns -EINVAL and this case is not handled in
> tty_ldisc_get(), so request_module() is not called.
> 
> Attached patch fixes this by calling request_module() if
> tty_ldisc_try_get() returned any error code.
> 
> I discovered this when my UMTS modem stopped working with 2.6.27-rc1
> because module ppp_async was not loaded.
> 
> Signed-off-by: Eugeniy Meshcheryakov <eugen@debian.org>

Signed-off-by: Alan Cox <alan@redhat.com>

(And forwarded to the stable tree too)
