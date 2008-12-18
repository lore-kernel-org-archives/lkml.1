Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbYLRXOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbYLRXOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYLRXOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:14:23 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:5649 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYLRXOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:14:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=shdbeX8mrxSyBGD23BbIsu0x2enDPivVRsa3zKalZMQTkXmoSdu1WcAKUTh3wdYiPn
         WJadl6m4Ota/WS6dB9vfTuixCwLyHH9GBnoGLLVmmyBtqh3IopWUeZbE0muFLhTpSC6N
         1cTcdzD8EwI76RhN8IVn+o1ygDxjdGbVOfQr4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ide: Fix ata_id_has_dword_io to return DWORD I/O support properly
Date: Fri, 19 Dec 2008 00:13:09 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc8-next-20081218; KDE/4.1.3; i686; ; )
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Jeff Garzik <jeff@garzik.org>,
       Mario Schwalbe <schwalbe@inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
References: <494A5BBF.8000807@inf.tu-dresden.de> <200812182142.16533.bzolnier@gmail.com> <20081218224010.45e3ce55@lxorguk.ukuu.org.uk>
In-Reply-To: <20081218224010.45e3ce55@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812190013.10156.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2008, Alan Cox wrote:
> > OTOH the current patch is safe even for 2.6.28 (based on years of experience
> > with the check that we had in IDE subsystem) and will fix some libata drivers
> > (pata_legacy, pata_qdi and pata_winbond) to use dword IO on >= ATA-2 devices.
> > 
> > [ In reality this a regression fix for IDE -> libata conversion as it is a
> >   huge performance improvement for the above mentioned DMA-less drivers. ]
> 
> The 32bit PIO support is already queued up and went to Jeff a while ago
> so thats all in hand - its btw a big win on some suprising chipset cases
> including Intel ICH chipsets.

It is a not exactly the same issue as the pata_{legacy,qdi,winbond} one
discussed above.  Anyway cool to see another IDE -> libata regression fixed.

> > Jeff, I would like to merge it through IDE tree since the other patch depends
> > on it but if you want to go ahead and push it to Linus earlier feel free to
> > do it (or I can include it into the next IDE fixes pull request if you like).
> 
> Its still broken. You cannot use the version check for versions below 3.

Hmm, this doesn't seem to be a problem w.r.t. to the patch we are discussing
because in such case ata_id_major_version() will just return 0 and the check
will behave in the identical way as it was before the patch.

> I remain unconvinced we should be looking at it anywhere except specific
> pure ISA cycle pass through hardware and thus it belongs as a helper for
> those drivers not as ata_has_mumble stuff as its not ATA - eide_* maybe.

Sure, we can always improve things further later.  However Mario's patch
is _definitely_ an improvement over the _current_ code.  Don't you agree?

[ There are no alternative patches to consider currently so... ]

Thanks,
Bart
