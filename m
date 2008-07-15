Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbYGORRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbYGORRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYGORRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:17:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53576 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbYGORQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:16:59 -0400
Message-ID: <487CDB85.3050208@garzik.org>
Date: Tue, 15 Jul 2008 13:16:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Woodhouse <dwmw2@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>  <487C09EB.1050903@garzik.org>  <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org>  <487C1648.5070409@garzik.org>  <alpine.LFD.1.10.0807142027140.3017@woody.linux-foundation.org>  <487C500F.8000109@garzik.org> <1216107418.27455.236.camel@shinybook.infradead.org> <487C5ABE.2010907@garzik.org> <alpine.LFD.1.10.0807150808050.3017@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807150808050.3017@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I call bullshit. You don't like the change - ok.

SIGH.  Wrong, wrong, wrong.  I have always thought request_firmware() 
was a good idea, even if it decreased reliability.  Because we need that 
ability and that API.

The changes are good,

They just don't need to break stuff.

Which they do.


> But stop making bogus 
> arguments about it.

How many more real world examples of breakage do you need?

* This breaks newer kernel / older userland
* This breaks anywhere with a file list for modules' contents (ipkg 
kernel module packages)
* This breaks driver disk build packages
* This breaks for the oddball, not just me, who
* This breaks for an unknown amount of people who have been assuming 
that their driver will always work when modprobe'd, even though they are 
completely unaware of its new firmware needs

All these are cases in use today.  Real users, Linus.  Real distros.

	Jeff


P.S.  And as I stated in another email, I'm happy to help fix this 
regression.

