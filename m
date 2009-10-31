Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbZJaV5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbZJaV5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 17:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbZJaV5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 17:57:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765AbZJaV5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 17:57:50 -0400
Date: Sat, 31 Oct 2009 14:57:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
In-Reply-To: <200910312252.39446.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.01.0910311455520.31845@localhost.localdomain>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200910312227.15493.rjw@sisk.pl> <alpine.LFD.2.01.0910311441120.31845@localhost.localdomain> <200910312252.39446.rjw@sisk.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 Oct 2009, Rafael J. Wysocki wrote:
> 
> Yes, there is, because socket_early_resume() only does it in
> the (skt->state & SOCKET_PRESENT) case.  If that bit is not set, the
> initialization is entirely postponed.

Ahh, ok. And what's the reason for that? It seems like the 

	skt->socket = dead_socket;
	skt->ops->init(skt);
	skt->ops->set_socket(skt, &skt->socket);

thing should always be safe, whether there is something present or not.. ?

		Linus
