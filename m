Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbXLFFEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbXLFFEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 00:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXLFFEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 00:04:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:53610 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbXLFFEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 00:04:34 -0500
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ralf Baechle <ralf@linux-mips.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	 <1196899818.7033.11.camel@pasglop>
	 <200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 16:04:07 +1100
Message-Id: <1196917447.7033.17.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-06 at 13:34 +0900, Yoichi Yuasa wrote:
> > I don't understand how his fix can work on MIPS nor why the previous
> > code didn't, but I don't know how MIPS does its remapping tricks,
> > however it will definitely -not- work on powerpc (and will break a
> > couple of machines out there).
> 
> MIPS pcibios_fixup_bus() converts RAW BAR values(including offset) to
> resource values. How does it fix up on powerpc?

Same thing. We expect resources to contain raw values before . What I
don't understand is thus why you are calling resource_to_bus on 0x1f0
which is -not- a resource value, but is already a BAR value...

Ben.


