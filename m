Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbXJaLso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbXJaLso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbXJaLsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:48:36 -0400
Received: from [81.2.110.250] ([81.2.110.250]:35166 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753481AbXJaLsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:48:35 -0400
Date: Wed, 31 Oct 2007 11:49:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071031114958.210bd7cc@the-village.bc.nu>
In-Reply-To: <47278439.4030801@gentoo.org>
References: <47274A5F.6070409@gentoo.org>
	<20071030153417.59b9182c@the-village.bc.nu>
	<47276DCA.1000808@gentoo.org>
	<20071030190153.373c9347@the-village.bc.nu>
	<47278439.4030801@gentoo.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 19:21:29 +0000
Daniel Drake <dsd@gentoo.org> wrote:

> Alan Cox wrote:
> > I would guess Brasero is issuing a command with the length of data
> > wrongly set. In the old code that might well just produce errors of the
> > "Umm wtf is this data left over for ?", with the new code the drive is
> > likely to change state as it knows the transfer size and that will
> > *correctly* cause an HSM error and what follows.
> > 
> > Now the question is who gets the length wrong - Brasero or the ata
> > translation code in libata
> 
> Brasero does exactly the same as my test app which I attached to my last 
> mail. Is my test app wrong?

Would need to double check the SCSI specificatons to be sure but I think
you are asking for less data than the drive wishes to provide. You
aren't allowed to do that with ATA.

Alan
