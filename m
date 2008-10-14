Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbYJNJvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbYJNJvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYJNJv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:51:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32937 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754059AbYJNJv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:51:27 -0400
Date: Tue, 14 Oct 2008 10:44:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 4/5] hvc_console: Add tty window resizing
Message-ID: <20081014104428.698b750b@lxorguk.ukuu.org.uk>
In-Reply-To: <20081014091413.306993844@linux.vnet.ibm.com>
References: <20081014091247.433079967@linux.vnet.ibm.com>
	<20081014091413.306993844@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	hp = container_of(work, struct hvc_struct, tty_resize);
> +	if (!hp || !hp->tty)
> +		return;

What locks hp->tty here, it can go NULL after the test on a hangup it
seems ?

> + * hvc_resize() - Update terminal window size information.
> + * @hp:		HVC console pointer
> + * @ws:		Terminal window size structure

See tty_do_resize() for all of this stuff in the latest git. If you can't
use tty_do_resize from your work queue then please let me know why as I'd
like everyone to be using one abstraction.

We also now have a "resize" operation for devices that want to react to a
resize from TIOCSWINSZ
