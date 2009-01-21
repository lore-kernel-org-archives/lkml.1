Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbZAUPdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbZAUPdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZAUPdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:33:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37020 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752921AbZAUPdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:33:13 -0500
Date: Wed, 21 Jan 2009 15:32:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam Bliss <abliss@google.com>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@flint.arm.linux.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: tty_tiocmset() masks out TIOCM_RI and TIOCM_CD, which breaks
 rfcomm
Message-ID: <20090121153229.4a11cb8e@lxorguk.ukuu.org.uk>
In-Reply-To: <ee007d8e0901201524s3be5e8e2m7d1d4026c078a87@mail.gmail.com>
References: <ee007d8e0901201524s3be5e8e2m7d1d4026c078a87@mail.gmail.com>
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

> TIOCM_CD and TIOCM_RI to the list?  Like this:

CD and RI are inputs which is why they are masked.

> Traditionally, RI (Ring Indicator) and CD (Carrier Detect) were
> typically used for DCE -> DTE communication, so perhaps this is why
> they were left off initially.  However, when Bluetooth is used to

The cables end up doing the conversion so the PC world always sees them
from the one end - even if they are in fact crossed over in the cable.

> It might be appropriate to include other signals as well, such as CTS
> and DSR.  However, these do not seem necessary for rfcomm, since the
> rfcomm driver will interpret a DTR as a DSR and an RTS as a CTS.  My
> main concern is for RI and CD, for which there does not seem to be a
> workaround.

I would have expected the driver to be remapping RI/CD just as it does
for the DTR<->DSR RTS<->CTS cable switch around.

It's certainly possible to fix it, but that would need a double check on
the existing drivers and that passing new suprise bits won't do any harm.
The real question is what should the right behaviour be - and to me that
seems to be to logically flip all the lines not just DTR/DSR RTS/CTS
