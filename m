Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbZFHPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbZFHPcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 11:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZFHPcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 11:32:07 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43356 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753569AbZFHPcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 11:32:06 -0400
Subject: Re: 2.6.30-rc8 Oops whilst booting
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Chris Clayton <chris2553@googlemail.com>
Cc: NeilBrown <neilb@suse.de>, Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <c6b1100b0906080817q5378f512s8ce03727a362e8c5@mail.gmail.com>
References: <200906061959.55592.chris2553@googlemail.com>
	 <200906062215.30571.chris2553@googlemail.com>
	 <1244381140.30664.12.camel@ht.satnam>
	 <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>
	 <1244413881.18742.31.camel@ht.satnam>
	 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>
	 <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
	 <1244471000.4079.36.camel@mulgrave.site>
	 <c6b1100b0906080817q5378f512s8ce03727a362e8c5@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 15:32:04 +0000
Message-Id: <1244475124.4079.177.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 16:17 +0100, Chris Clayton wrote:
> > Actually, you can save yourself a lot of pain by mounting by label
> > instead ... that way both grub and fstab will find your root disc even
> > if it has swapped order.
> >
> 
> Would I be right in assuming from this that "out-of-order" detection
> is expected behaviour? If so, I'll fix up my system and shut up :-) I
> suspect I may not be the only person on the planet who specifies the
> root filesystem in this way, though.

Yes and no ... yes generally because parallel asynchronous probing does
relax the ordering rules, so if you have multiple devices the ordering
can easily change.  No in your particular case because you have a single
ata_piix and even with async enabled it should probe PATA first (master
and slave) followed by SATA.  The fact that the PATA and SATA probes
didn't synchronise is a bug somewhere, but I'm not sure where.

Could you fix your system to do the label mounting and post the full
boot log where it's out of sequence?  I have a nasty feeling we might
have got the ata probe order correct only to be thrown out of order by
sd driver attachment.

James


