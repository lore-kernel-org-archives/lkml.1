Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbYJFRLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbYJFRLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYJFRLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:11:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54113 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbYJFRLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:11:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes (Re: 2.6.27-rc8+ - first impressions)
Date: Mon, 6 Oct 2008 19:15:10 +0200
User-Agent: KMail/1.9.9
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jason Vas Dias <jason.vas.dias@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <20081005183603.GA3263@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810061915.11936.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 6 of October 2008, Linus Torvalds wrote:
> 
> On Mon, 6 Oct 2008, Rafael J. Wysocki wrote:
> > 
> > Unfortunately some of the recent IO-APIC changes made the bug show
> > up.  To prevent this from happening, blacklist machines that are
> > known to be affected (nx6115 and 6715b in this particular case).
> 
> Can you point to exactly _which_ recent change made it show up? I'd really 
> like to know. _What_ was it that made us suddenly need this quirk when it 
> wasn't necessary before? I'd like to understand the root cause here.

On my box it was caused by:

commit 691874fa96d6349a8b60f8ea9c2bae52ece79941
Author: Maciej W. Rozycki <macro@linux-mips.org>
Date:   Tue May 27 21:19:51 2008 +0100

    x86: I/O APIC: timer through 8259A second-chance

    Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

and the whole story is described in this (huge) thread:
http://marc.info/?l=linux-kernel&m=121358440508410&w=4

> And how did you even start looking at that strange ACPI override? 

Well, Matthew Garrett told us about that happening on the nx6125:

http://marc.info/?l=linux-kernel&m=121396307411930&w=4

and then Maciej analysed the breakage on the basis of a DSDT from the nx6325:

http://marc.info/?l=linux-kernel&m=121401068718826&w=4

As far as the Dmitry's and Jason's boxes are concerned, I recognized the
symptoms and asked them to verify that the blacklisting helped.

It appears that the buggy BIOS code has been copy-pasted to the entire range of
machines, for no good reason.

Thanks,
Rafael
