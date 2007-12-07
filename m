Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbXLGSsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbXLGSsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXLGSsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:48:25 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56260 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753474AbXLGSsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:48:24 -0500
Date: Fri, 7 Dec 2007 18:42:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andi Kleen <andi@firstfloor.org>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071207184237.04174f42@the-village.bc.nu>
In-Reply-To: <475994C5.7090307@keyaccess.nl>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<20071207163116.GB5992@one.firstfloor.org>
	<20071207171957.73b619b1@the-village.bc.nu>
	<475994C5.7090307@keyaccess.nl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2007 19:45:25 +0100
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 07-12-07 18:19, Alan Cox wrote:
> 
> > On Fri, 7 Dec 2007 17:31:16 +0100
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> >>> You don't need to. Port 0x80 historically is about 8uS so just udelay(8)
> >>> and make sure the initial default delay is conservative enough before the
> >> How would you make it conservative enough handling let's say a 6Ghz CPU
> >> that can execute multiple jumps per cycle?
> > 
> > Pick a sane worst case and go with it at boot. We don't have to be
> > accurate before we tune udelay - over long in uSecs isnt going to hurt,
> > and most post boot _p's can be replaced by udelay(8) now
> 
> Isn't 8 generally a bit overly long? I believe the norm is 1?

8uS is an ISA bus transaction.
