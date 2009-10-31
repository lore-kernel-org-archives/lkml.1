Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbZJaWI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbZJaWI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 18:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933294AbZJaWI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 18:08:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59259 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933251AbZJaWI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 18:08:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Date: Sat, 31 Oct 2009 23:10:24 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200910312252.39446.rjw@sisk.pl> <alpine.LFD.2.01.0910311455520.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910311455520.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910312310.24180.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 October 2009, Linus Torvalds wrote:
> 
> On Sat, 31 Oct 2009, Rafael J. Wysocki wrote:
> > 
> > Yes, there is, because socket_early_resume() only does it in
> > the (skt->state & SOCKET_PRESENT) case.  If that bit is not set, the
> > initialization is entirely postponed.
> 
> Ahh, ok. And what's the reason for that? It seems like the 
> 
> 	skt->socket = dead_socket;
> 	skt->ops->init(skt);
> 	skt->ops->set_socket(skt, &skt->socket);
> 
> thing should always be safe, whether there is something present or not.. ?

It should, but I'm not sure given the reported behavior so far.

I guess I'll prepare another patch that does this unconditionally in the
early phase and let's see how that works.

Rafael
