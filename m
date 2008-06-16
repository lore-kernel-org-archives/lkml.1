Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbYFPMD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbYFPMD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYFPMDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:03:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54275 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752692AbYFPMDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:03:50 -0400
Date: Mon, 16 Jun 2008 12:46:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Johannes Weiner <hannes@saeurebad.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10741] bug in `tty: BKL pushdown'?
Message-ID: <20080616124602.54910afd@lxorguk.ukuu.org.uk>
In-Reply-To: <20080616113313.2f932f8d@lxorguk.ukuu.org.uk>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	<Jn7irxIunJK.A.B-E.dKDVIB@albercik>
	<873andbst2.fsf@saeurebad.de>
	<20080616113313.2f932f8d@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 11:33:13 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > The bug still exists, however, a bisect on another machine with the same
> > userland leads to different commit
> > (47f86834bbd4193139d61d659bebf9ab9d691e37 "redo locking of tty->pgrp"),
> > so it is not all that clear and stable.
> 
> Now that would actually make a lot more sense as a root cause.

Experiment time. In _proc_set_tty() in tty_io.c move the

	tty->session = get_pid(task_session(tsk));

back inside the lock just before

	tty->pgrp = get_pid(task_pgrp(tsk));

Alan
--
  "Standards committees don't like hashing.  It looks complicated and
    insufficiently deterministic on an overhead projector."
					- Vern Schryver
