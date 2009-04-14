Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbZDNPP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbZDNPP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZDNPPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:15:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:46659 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbZDNPPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:15:45 -0400
Date: Tue, 14 Apr 2009 08:17:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, linux-acpi@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [BISECTED] EEE PC hangs when booting off battery
Message-ID: <20090414081728.10de978a@infradead.org>
In-Reply-To: <200904140859.02188.bjorn.helgaas@hp.com>
References: <49E065CF.6040408@tuffmail.co.uk>
	<49E44415.1040500@tuffmail.co.uk>
	<49E456B5.6030006@tuffmail.co.uk>
	<200904140859.02188.bjorn.helgaas@hp.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 08:59:01 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> I can't help with the real problem of why the asynchronous battery
> init causes the hang.

that got fixed already for the module case.

> 
> But I do object to the magic makefile ordering change in that commit.
> Nobody reading the makefile can tell why battery is down at the end,
> and moving it apparently slows down boot significantly. 

for all cases I've seen it actually speeds it up, because the battery
now runs concurrently with the disk probe.

> So the
> ordering change just feels like a band-aid that covers up a place
> where ACPI could be improved.

the reason for the move is that both the battery and other pieces take
the big acpi lock; which defeats the parallelism. So the battery needs
to happen at the end instead.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
