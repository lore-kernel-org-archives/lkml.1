Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYKTQju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYKTQju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYKTQjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:39:41 -0500
Received: from mail.pcs.de ([145.253.69.50]:33432 "EHLO mail.pcs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYKTQjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:39:40 -0500
Date: Thu, 20 Nov 2008 17:39:38 +0100 (CET)
From: Thomas Pfaff <tpfaff@pcs.com>
X-X-Sender: tpfaff@lxtpfaff.pcs.ditec.de
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Question about TTY_DO_WRITE_WAKEUP
In-Reply-To: <20081120155502.608812d9@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0811201700320.1274@lxtpfaff.pcs.ditec.de>
References: <Pine.LNX.4.64.0811201007120.30713@lxtpfaff.pcs.ditec.de>
 <20081120131726.2636b559@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0811201446380.21561@lxtpfaff.pcs.ditec.de>
 <20081120143147.5e8d6c20@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0811201536150.23073@lxtpfaff.pcs.ditec.de>
 <20081120155502.608812d9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 20 Nov 2008 16:39:38.0584 (UTC) FILETIME=[94535D80:01C94B2E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Nov 2008, Alan Cox wrote:

> > But n_tty_write_wakeup is only called from tty_wakeup when this bit is already 
> > set, therefore it makes no sense to set this bit in n_tty_write_wakeup again.
> 
> The base code should probably really use test_and_clear_bit() when
> calling that method.

Why should you test it, clear it and set it again in n_tty_write_wakeup ?

> > 
> > The flow looks to me as
> > 
> > If the tty driver sets TTY_DO_WRITE_WAKEUP a SIGIO is generated on every 
> > tty_wakeup.
> > 
> > If it is not set then n_tty_write_wakeup is never called and a SIGIO is not 
> > generated.
> 
> Which isn't perfect (excess SIGIO cases) but doesn't seem incorrect. If
> you've not blocked the tty output buffer then write() has not returned a
> short write and no SIGIO is due.
> 

Of course this is not incorrect, but this does not solve my problem with the 
TTY_DO_WRITE_WAKEUP flag.

IMHO a SIGIO on write possible should always be generated if the user wants it, 
currently it is generated when the user wants it and the tty driver enables the 
TTY_DO_WRITE_WAKEUP flag. Unfortunately most drivers don't set it.

Regarding excess SIGIO cases:

Once a write fails with EAGAIN a flag can be set and only in that case a SIGIO is 
generated, afterwards the bit is cleared. Maybe that is what TTY_DO_WRITE_WAKEUP 
was intended for. 

Thomas
