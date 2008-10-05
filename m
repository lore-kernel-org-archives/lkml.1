Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYJESRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYJESRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 14:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbYJESR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 14:17:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47230 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754744AbYJESR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 14:17:28 -0400
Date: Sun, 5 Oct 2008 19:15:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] kmemcheck: fix crash in PnP BIOS calls
Message-ID: <20081005191555.5715da29@lxorguk.ukuu.org.uk>
In-Reply-To: <20081005172504.GB24825@localhost.localdomain>
References: <20081005172504.GB24825@localhost.localdomain>
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

> It turns out that BIOS calls are made with a different code segment. So
> when kmemcheck tries to dereference the EIP/RIP (using the kernel data
> segment register), we get the unhandled page fault.
> 
> I think we can solve this by verifying (in the page fault handler) that
> the faulting code is using the kernel CS.

That isn't an entirely safe assumption and some services such as BIOS32
are 32bit. Would it be better wrap BIOS calls with a kmemcheck wrapper
which changes the way kmemcheck works/dumps stuff and also gives you a
hook after BIOS calls to do stuff like corruption scans or change
detection on kernel pages ?

Alan
