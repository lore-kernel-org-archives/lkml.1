Return-Path: <linux-kernel-owner+w=401wt.eu-S933334AbZJaVpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbZJaVpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 17:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933328AbZJaVpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 17:45:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933323AbZJaVpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 17:45:08 -0400
Date: Sat, 31 Oct 2009 14:44:49 -0700 (PDT)
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
In-Reply-To: <200910312227.15493.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.01.0910311441120.31845@localhost.localdomain>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200910311031.17660.rjw@sisk.pl> <1257022890.7907.14.camel@pasglop> <200910312227.15493.rjw@sisk.pl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 Oct 2009, Rafael J. Wysocki wrote:
> 
> The patch is appended, please have a look.

Looks sane to me. It does the actual real socket ops early, and does the 
crazy pcmcia resume late. 

And I like how you abstracted out that dev->socket thing in 
pcmcia_socket_dev_run().

The only thing that looks odd is how you do "socket_start_resume()" in the 
"late_resume" path too - that has already been done by the early_resume, 
and as far as I can see you're now initializing the socket twice.

Is there a reason for that? Or am I misreading the patch (I didn't 
actually apply it, I just read the patch itself).

		Linus
