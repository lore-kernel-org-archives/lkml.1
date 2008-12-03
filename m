Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYLCPzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYLCPzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYLCPzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:55:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45837 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753273AbYLCPzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:55:36 -0500
Date: Wed, 3 Dec 2008 15:54:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Pavel Machek <pavel@suse.cz>, Theodore Tso <tytso@mit.edu>,
       Chris Friesen <cfriesen@nortel.com>,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081203155449.6ea98768@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0812031637050.5406@artax.karlin.mff.cuni.cz>
References: <20081202094059.GA2585@elf.ucw.cz>
	<20081202140439.GF16172@mit.edu>
	<20081202152618.GA1646@ucw.cz>
	<20081202163720.GB18162@mit.edu>
	<49356EF2.7060806@nortel.com>
	<20081202205558.GD20858@mit.edu>
	<20081202224403.GA8277@elf.ucw.cz>
	<20081203050709.GL20858@mit.edu>
	<20081203084639.GB1944@ucw.cz>
	<Pine.LNX.4.64.0812031637050.5406@artax.karlin.mff.cuni.cz>
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

> implemented in disk firmware. Write errors are reported for disk 
> connection problems, not media problems.

Media errors are reported for writes when the drive knows there are
problems. That may be deferred to the cache flush afterwards but the
information is still generated and shipped back to us - eventually.

> For connection problems, another solution may be to retry writes 
> indefinitely until the admin aborts it or reconnects the disk. But I don't 
> know how common these recoverable disk connection errors are.

CRC errors, lost IRQs and the like are retried by the midlayer and
drivers and the error handling strategies will also try things like
reducing link speeds on repeated CRC errors.

Alan
