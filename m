Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbYFWKjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbYFWKjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbYFWKja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:39:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:59052 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbYFWKja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:39:30 -0400
Subject: Re: sata_svw data corruption, strange problems
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <tj@kernel.org>, Pavel Machek <pavel@suse.cz>,
       Andreas Schwab <schwab@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>, jgarzik@pobox.com,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
In-Reply-To: <20080623104221.3b4fb350@lxorguk.ukuu.org.uk>
References: <20080617093602.GA28140@elf.ucw.cz>
	 <485EF061.3010601@kernel.org> <20080623082055.GB1850@elf.ucw.cz>
	 <je63s0sfxv.fsf@sykes.suse.de> <20080623085338.GE1850@elf.ucw.cz>
	 <485F6540.6000907@kernel.org> <20080623090130.GF1850@elf.ucw.cz>
	 <1214211859.8011.250.camel@pasglop> <485F7184.1030907@kernel.org>
	 <20080623104221.3b4fb350@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 20:23:22 +1000
Message-Id: <1214216602.8011.259.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 10:42 +0100, Alan Cox wrote:
> > > BTW. Tejun, I suppose that usually starting DMA after issuing the
> > > command is a standard practice of legacy/sff type controllers ? Or it's
> > > just because that's how linux did it until now ?
> > 
> > It's how the standard says it should be programmed.  Please take a look
> > at section 3 of the following document.
> > 
> > http://www.centrillium-it.com/Projects/idems100.pdf
> > 
> > It's a non-issue for PATA ones as the host is responsible for running
> 
> It's very much an issue for PATA. If you start the DMA before time things
> go wrong. The DMA has to start after the command is issued (or for ATAPI
> after the command and the cdb are issued). Various ATAPI devices get
> quite cross if you mess this up.
> 
> In some cases the driver code also depends upon this as we software drive
> the data clocks so have to reprogram them after command issue and before
> data transfer begins.

Might explain why those broadcom chipsets are also allergic to ATAPI
DMA :-)

Ben.


