Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYHLTmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYHLTmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYHLTmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:42:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33232 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386AbYHLTmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:42:38 -0400
Date: Tue, 12 Aug 2008 20:24:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Marcin Obara" <marcin_obara@users.sourceforge.net>
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-ID: <20080812202445.5ac3c8d1@lxorguk.ukuu.org.uk>
In-Reply-To: <ea8d860a0808121224y63bd4178xe0c74d5fb3e34180@mail.gmail.com>
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>
	<alpine.DEB.1.00.0807180742560.7868@ip-195-3-221-75.vnet.pl>
	<alpine.DEB.1.00.0807181938180.12442@ip-195-3-221-75.vnet.pl>
	<alpine.DEB.1.00.0807182122460.24146@ip-195-3-221-75.vnet.pl>
	<alpine.DEB.1.00.0807182229070.30162@ip-195-3-221-75.vnet.pl>
	<alpine.DEB.1.00.0807231958130.20791@ip-195-3-221-75.vnet.pl>
	<alpine.DEB.1.00.0808112115140.6724@ip-195-3-221-75.vnet.pl>
	<20080811215340.2c0635dd.akpm@linux-foundation.org>
	<48A1B71C.6080201@gmail.com>
	<ea8d860a0808121224y63bd4178xe0c74d5fb3e34180@mail.gmail.com>
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

> This source code was designed few years ago and there is already
> written userspace software.

Diddums that is what you get for keeping stuff away from upstream

> Removal of driver internal error codes may affect software.
> I think it is more risky than keeping these own errno numbers.

I would disagree. We use ERR_PTR() and other macros with errors. Using
strange numbers is asking for risk.
> 
> >
> > E.g. unlocked_ioctl switch hasn't been done plus other things mentioned
> > below too (not all of them)
> >
> unlocked_ioctl would require to add lock as big kernel lock replacement.
> It is risky in such complex code, especially if speed increase is not expected.
>
>  We don't want to init_timer() here. It is done later, to avoid race condition.
> We only configure timer, but we are not ready to start it.

init_timer does not start a timer.
 
> >
> >>> +/* IOCTL commands */
> >>> +#define IOCTL_HECI_GET_VERSION \
> >>> +    _IOWR('H' , 0x0, struct heci_message_data)
> > ... and conflicts with hid as I commented before.
> 
> Sorry for missing explanations.
> This conflict can't be avoided, because there is already written
> software that depends on these ioctl definitions.

See "diddums" message above. You mess up tools like strace if you don't
fix this and strace is more important than some minor driver detail
caused by not upstreaming code earlier.

The non unlocked version of ioctl() is going away and the BKL will in
time follow so you might as well deal with that now too.

