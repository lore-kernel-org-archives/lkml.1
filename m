Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZFBAUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZFBAUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZFBAUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:20:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47335 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbZFBAUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:20:32 -0400
Date: Mon, 1 Jun 2009 20:19:51 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Martin Mueller <mm@sig21.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel locks up when idle on VIA-nano U2300 with VIA VX800 on
 Jetway JNF76-N1GL-LF mainboard
Message-ID: <20090601201951.01a48d3e@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20090426170602.GA26009@catull.sig21.net>
References: <20090426095121.GS26701@catull.sig21.net>
	<gt1jsf$hb8$1@ger.gmane.org>
	<20090426170602.GA26009@catull.sig21.net>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009 19:06:02 +0200
Martin Mueller <mm@sig21.net> wrote:

> Hi Jeffrey,
> 
> On Sun, Apr 26, 2009 at 12:25:51PM +0000, Jeffrey Cao wrote:
> > On 2009-04-26, Martin Mueller <mm@sig21.net> wrote:
> 
> > > Next, I downloaded linux-2.6.30-rc3, compiled a minimal version with
> > > just initrd. I left out PCI-support, ACPI and almost everything else
> > > menuconfig allowed me to unselect except the VGA text console. This
> > > kernel locked up after giving me the initial prompt from busybox in
> > > the initrd.
> > >
> > > When adding the following lines in the script executed by the kernel
> > > after booting in the initrd, the system actually works:
> > >
> > >   while true; do true; done &
> > >   /bin/sh
> > >
> > > As soon as I kill the shell loop, the system freezes again.
> > >
> > > So my conclusion is: the kernel locks up the first time the CPU
> > > is idle.
> 
> > This seems something to do with the board and the hard disk drive.
> 
> Thanks for your suggestion, but it has nothing to do with the hardisk.
> As I wrote above, the problem is reproducible with only an initrd, vga
> text console, keyboard and no other driver loaded or compiled in.
> 
> The kernel freezes as soon as it get's idle the first time.
> 

Adding idle=halt to the boot options works. idle=nomwait should work too but
it doesn't.
