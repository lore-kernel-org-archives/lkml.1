Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbXCLVOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbXCLVOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbXCLVOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:14:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:24971 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbXCLVO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:14:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,275,1170662400"; 
   d="scan'208"; a="208317924:sNHT18793278"
Date: Mon, 12 Mar 2007 14:11:26 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, len.brown@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: libata-acpi: allow _GTF on SATA, but disable on PATA for now
Message-Id: <20070312141126.651cf967.kristen.c.accardi@intel.com>
In-Reply-To: <20070312220015.094b7759@lxorguk.ukuu.org.uk>
References: <200703100559.l2A5x6kP017578@hera.kernel.org>
	<45F296B9.7000005@garzik.org>
	<20070310164059.4ba68bcc@lxorguk.ukuu.org.uk>
	<20070312095528.3dd7a693.kristen.c.accardi@intel.com>
	<20070312220015.094b7759@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007 22:00:15 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Meanwhile, to solve the problem for these people, and without introducing
> > a lot of new code at this stage in the release, perhaps you can suggest 
> > a more accurate way to detect PATA vs. SATA so we can fix the bug?  
> 
> I think the problem starts with the question. It supposes the BIOS knows
> the answer to the question in the first place. It also supposes we
> haven't reconfigured the port in some cases I believe.
> 
> My guess is the problem needs approaching from the other end. Ask the
> question "What does the ACPI BIOS expect it to be ?". If I follow the
> spec correctly we can answer that question by asking what methods (_SDD,
> _GTF etc) it provides.
> 
> I don't think anything else is reliable.
> 
> Alan
> 

Ah - ok, so you are saying we could query the device to see if it supports
STM/GTM and then if we were to use the workaround I suggested for this bug
we could just refuse to execute GTF on devices which support STM (since
they may require execution of STM first).  If you guys decide you want 
the workaround rather than just either disable acpi or remove the acpi patch
entirely, let me know and I'd be glad to rework it, otherwise I'm assuming
you have decided to just disable acpi all together.
