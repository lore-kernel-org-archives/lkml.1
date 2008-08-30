Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYH3USW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYH3USW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYH3USM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:18:12 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62891 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753229AbYH3USL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:18:11 -0400
Date: Sat, 30 Aug 2008 21:16:58 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Frans Pop <elendil@planet.nl>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc3: 'APIC error on CPU1: 00(40)', but only on resume!
In-Reply-To: <200808302116.07421.elendil@planet.nl>
Message-ID: <Pine.LNX.4.55.0808302106140.29414@cliff.in.clinika.pl>
References: <200808202106.41058.elendil@planet.nl> <200808202356.33036.rjw@sisk.pl>
 <Pine.LNX.4.55.0808211023020.22938@cliff.in.clinika.pl>
 <200808302116.07421.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008, Frans Pop wrote:

> >  Barring a hardware erratum, this is a bug in the kernel.  It should be
> > moderately easy to track down with some debugging added to writes
> > accessing LVT and redirection table entries.
> 
> Could you please provide some more specific debugging instructions? I'm at 
> a complete loss what I should do here.

 Debugging code can be added to apic_write() and io_apic_{write,modify}()  
so that a warning is output into the kernel log whenever a suspicious
value is written to one of the vector registers.  Similarly for MSI/HT
interrupts, although I do not know names of the functions involved off the
head.  Due to performance considerations it is unfortunately infeasible to
have such debugging enabled in production kernels.

  Maciej
