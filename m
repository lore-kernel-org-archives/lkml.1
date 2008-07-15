Return-Path: <linux-kernel-owner+w=401wt.eu-S1762885AbYGOTIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762885AbYGOTIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761608AbYGOTIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:08:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762232AbYGOTIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:08:10 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Frans Pop <elendil@planet.nl>, arjan@infradead.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <487CF29E.5000009@garzik.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
	 <20080715180535.GA6080@khazad-dum.debian.net> <487CE917.3000000@garzik.org>
	 <alpine.LFD.1.10.0807151122010.3017@woody.linux-foundation.org>
	 <487CF29E.5000009@garzik.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 12:07:33 -0700
Message-Id: <1216148853.27455.346.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 14:55 -0400, Jeff Garzik wrote:
> Linus Torvalds wrote:
> > 
> > On Tue, 15 Jul 2008, Jeff Garzik wrote:
> > 
> >> Henrique de Moraes Holschuh wrote:
> >>> On Tue, 15 Jul 2008, Frans Pop wrote:
> >>>> If I were able to compile firmware into the modules, the problem would be
> >>>> solved in one go.
> >>> And this thread would have been shorter, even. I hope someone decides to
> >>> write that support instead of complaining ;-)
> >> I've volunteered -- but if Linus and David will reject my code out of hand,
> >> there is not much point in writing it.
> > 
> > Quite frankly, I don't think it's something to reject out of hand, but it 
> > does sound pretty damn stupid.
> > 
> > Why compile them into the module, when that's just the _inflexible_ model?
> 
> Because it works today.
> 
> Because that is what people and their scripts expect, today.
> 
> Because people should not be forced to fix all their firmware-related 
> breakage immediately, just to boot 2.6.27.

On one hand, they don't -- the drivers I've updated in 2.6.27 aren't the
ones they need to boot. I deliberately left drivers/net and drivers/scsi
till later. I don't _expect_ any problems, but there's no rush -- we can
iron out any kinks with the drivers I've done already, then merge the
remaining updates into 2.6.28.

One the other hand, they _do_ need to fix such breakage immediately, if
they have it -- because what I'm doing here is nothing new. Most modern
drivers use request_firmware() already.

So if your userspace has this hypothetical "firmware-related breakage"
of which you speak, then it already won't boot on machines with qla2xxx,
which was converted to use request_firmware() in 2005. To pick but one
example out of many.

-- 
dwmw2

