Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbYJNQ2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbYJNQ2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 12:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYJNQ20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 12:28:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35746 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752192AbYJNQ20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 12:28:26 -0400
Date: Tue, 14 Oct 2008 17:14:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC PATCH 4/5] hvc_console: Add tty window resizing
Message-ID: <20081014171408.228e681b@lxorguk.ukuu.org.uk>
In-Reply-To: <20081014150209.GB5318@cetus.boeblingen.de.ibm.com>
References: <20081014091247.433079967@linux.vnet.ibm.com>
	<20081014091413.306993844@linux.vnet.ibm.com>
	<20081014104428.698b750b@lxorguk.ukuu.org.uk>
	<20081014150209.GB5318@cetus.boeblingen.de.ibm.com>
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

> Since tty_do_resize() cannot be called holding the hp spinlock; the code uses
> now tty_kref_get/put to keep track of the tty object. I am not sure if the
> use of the kref's is correct here, so please let me know if there is a better
> solution.

That looks right to me, hp->tty can go NULL but the tty object itself
will still have a reference even if the asynchronous events kick off late

