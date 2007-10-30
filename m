Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbXJ3TA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbXJ3TA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbXJ3TAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:00:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35651 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753664AbXJ3TAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:00:15 -0400
Date: Tue, 30 Oct 2007 19:01:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071030190153.373c9347@the-village.bc.nu>
In-Reply-To: <47276DCA.1000808@gentoo.org>
References: <47274A5F.6070409@gentoo.org>
	<20071030153417.59b9182c@the-village.bc.nu>
	<47276DCA.1000808@gentoo.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The nutty app I was using for burning is Brasero, a GNOME app which does 
> some SG_IO directly with the drive. (I guess it has some bad error 
> handling and doesn't realise when some I/O path has failed)

I would guess Brasero is issuing a command with the length of data
wrongly set. In the old code that might well just produce errors of the
"Umm wtf is this data left over for ?", with the new code the drive is
likely to change state as it knows the transfer size and that will
*correctly* cause an HSM error and what follows.

Now the question is who gets the length wrong - Brasero or the ata
translation code in libata

Alan
