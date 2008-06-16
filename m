Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYFPPeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYFPPeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYFPPdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:33:51 -0400
Received: from saeurebad.de ([85.214.36.134]:56919 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbYFPPdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:33:20 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10741] bug in `tty: BKL pushdown'?
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	<Jn7irxIunJK.A.B-E.dKDVIB@albercik> <873andbst2.fsf@saeurebad.de>
	<20080616113313.2f932f8d@lxorguk.ukuu.org.uk>
	<20080616124602.54910afd@lxorguk.ukuu.org.uk>
Date: Mon, 16 Jun 2008 17:33:14 +0200
In-Reply-To: <20080616124602.54910afd@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Mon, 16 Jun 2008 12:46:02 +0100")
Message-ID: <87ve099yyt.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On Mon, 16 Jun 2008 11:33:13 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
>> > The bug still exists, however, a bisect on another machine with the same
>> > userland leads to different commit
>> > (47f86834bbd4193139d61d659bebf9ab9d691e37 "redo locking of tty->pgrp"),
>> > so it is not all that clear and stable.
>> 
>> Now that would actually make a lot more sense as a root cause.
>
> Experiment time. In _proc_set_tty() in tty_io.c move the
>
> 	tty->session = get_pid(task_session(tsk));
>
> back inside the lock just before
>
> 	tty->pgrp = get_pid(task_pgrp(tsk));

Like this:?

spin_lock()
put_pid()
put_pid()
tty->session =
tty->pgrp =
spin_unlock()

That does not fix it.

	Hannes
