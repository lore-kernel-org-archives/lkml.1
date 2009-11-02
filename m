Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZKBNh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZKBNh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbZKBNh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:37:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37495 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbZKBNhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:37:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Date: Mon, 2 Nov 2009 14:35:57 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200911010936.10409.rjw@sisk.pl> <20091101164736.GA5666@comet.dominikbrodowski.net>
In-Reply-To: <20091101164736.GA5666@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911021435.57884.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 November 2009, Dominik Brodowski wrote:
> Hey,
> 
> On Sun, Nov 01, 2009 at 09:36:10AM +0100, Rafael J. Wysocki wrote:
> > Commit 0c570cdeb8fdfcb354a3e9cd81bfc6a09c19de0c
> > (PM / yenta: Fix cardbus suspend/resume regression) caused resume to
> > fail on systems with two CardBus bridges.  While the exact nature
> > of the failure is not known at the moment, it can be worked around by
> > splitting the yenta resume into an early part, executed during the
> > early phase of resume, that will only resume the socket and power it
> > up if there was a card in it during suspend, and a late part,
> > executed during "regular" resume, that will carry out all of the
> > remaining yenta resume operations.
> > 
> > Fixes http://bugzilla.kernel.org/show_bug.cgi?id=14334, which is a
> > listed regression from 2.6.31.
> 
> The only issue I see is that we now return 0 unconditionally on the resume
> callbacks.

Hmm. pcmcia_socket_dev_suspend() and pcmcia_socket_dev_resume() return 0
unconditionally even without the patch, so it doesn't change that.

> Otherwise, it's
> 
> Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>

Thanks!

Rafael

