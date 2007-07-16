Return-Path: <linux-kernel-owner+w=401wt.eu-S1765036AbXGPPL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765036AbXGPPL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbXGPPLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:11:49 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:1420 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942AbXGPPLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:11:48 -0400
Date: Mon, 16 Jul 2007 16:11:45 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Songmao Tian <tiansm@lemote.com>
cc: LinuxBIOS Mailing List <linuxbios@linuxbios.org>, marc.jones@amd.com,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: about cs5536 interrupt ack
In-Reply-To: <4695D78F.8010806@lemote.com>
Message-ID: <Pine.LNX.4.64N.0707161556560.15539@blysk.ds.pg.gda.pl>
References: <4694A495.1050006@lemote.com> <Pine.LNX.4.64N.0707111347360.26459@blysk.ds.pg.gda.pl>
 <4694F4EB.8040000@lemote.com> <Pine.LNX.4.64N.0707111634430.26459@blysk.ds.pg.gda.pl>
 <4695D78F.8010806@lemote.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Songmao Tian wrote:

> 8259 problem  seems to be done with the attached patch, IDE hung seems to be
> the dma setting problem.
> 
> Thanks all for your advise, comments. I have learned a lot. now I continue to
> trace down the IDE problem.

 I would still recommend you to investigate the option of making the 8259A 
cores "transparent" and using the mapper registers to dispatch interrupts 
directly -- it would make processing of interrupt requests considerably 
faster and less complicated.  Please note that ffs() is O(1) and actually 
some two or three machine instructions on MIPS architecture processors and 
the model used by the mapper is closer to the spirit of how MIPS 
processors do interrupt handling.  With such an approach it will also 
likely be easier to integrate your changes upstream, than it would for 
your changes to i8259.{c,h} needed for your unusual setup to work.

 Of course as an intermediate solution during development to make the 
whole thing work the complicated use of the 8259A cores may be justified.

  Maciej
