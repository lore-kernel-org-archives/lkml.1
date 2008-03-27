Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbYC0Q1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbYC0Q1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYC0Q0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:26:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44168 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754619AbYC0Q0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:26:54 -0400
Date: Thu, 27 Mar 2008 16:10:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Serial Roadmap
Message-ID: <20080327161006.2db03b5a@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basic lock_kernel free serial is now pushed to the -mm tree, with a few
more lock drops to get pushed but tested.

After that the following will be changing

- tty->driver will no longer contain a copy of all the operations methods
but that will become tty->driver->ops and in turn tty->ops

- Helpers will appear for things like write_room/put_char/chars_in_buffer

These will be mandatory to use so that we can stamp out all the corner
cases where some combinations of ldisc/driver crash the box due to bogus
assumptions about what methods must be present.

- break_ctl will become mandatory for break handling removing all the
duplicated per driver cruft in old drivers.

- put_char methods will return 0/1 if they queued the character.

Alan
