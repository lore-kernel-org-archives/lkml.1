Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbXLFF6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbXLFF6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 00:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXLFF6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 00:58:30 -0500
Received: from mo32.po.2iij.net ([210.128.50.17]:1445 "EHLO mo32.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbXLFF6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 00:58:30 -0500
Message-Id: <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
Date: Thu, 6 Dec 2007 14:58:13 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: benh@kernel.crashing.org
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ralf Baechle <ralf@linux-mips.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
In-Reply-To: <1196917447.7033.17.camel@pasglop>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	<1196899818.7033.11.camel@pasglop>
	<200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net>
	<1196917447.7033.17.camel@pasglop>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Dec 2007 16:04:07 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> On Thu, 2007-12-06 at 13:34 +0900, Yoichi Yuasa wrote:
> > > I don't understand how his fix can work on MIPS nor why the previous
> > > code didn't, but I don't know how MIPS does its remapping tricks,
> > > however it will definitely -not- work on powerpc (and will break a
> > > couple of machines out there).
> > 
> > MIPS pcibios_fixup_bus() converts RAW BAR values(including offset) to
> > resource values. How does it fix up on powerpc?
> 
> Same thing. We expect resources to contain raw values before .

Same.

> What I don't understand is thus why you are calling resource_to_bus on 0x1f0
> which is -not- a resource value, but is already a BAR value...

0x1f0 is resource value on MIPS Cobalt.
All RAW BAR values contain the offset(0x10000000) on it.

Do the BAR values on your target contain the offset?

Yoichi



