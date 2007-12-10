Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbXLJAEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbXLJAEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 19:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXLJAEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 19:04:37 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:44487 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbXLJAEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 19:04:36 -0500
Date: Mon, 10 Dec 2007 01:04:31 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Robert Hancock <hancockr@shaw.ca>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071210000429.GA3916@rhlx01.hs-esslingen.de>
References: <fa.qQhD8aJpiTOFaZqjRYwoaG7YT1c@ifi.uio.no> <fa.yaP86AixGhz5Q7eXSu04pIQp6ho@ifi.uio.no> <fa.c3k8VKWAx4HIo9zXWbL5Ek0oSBw@ifi.uio.no> <fa.C8ACnOhs8bXB++vmugf5F34JcJg@ifi.uio.no> <fa.5o6E6S0UWnARbQPxLe30TvLQIiY@ifi.uio.no> <475AE150.9050306@shaw.ca> <20071209213642.GA27096@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209213642.GA27096@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Dec 09, 2007 at 10:36:42PM +0100, Andreas Mohr wrote:
> And the second, possibly much more lucrative, question would be
> whether we're actually doing something wrong with our ACPI _GTM execution
> which triggers the AE_AML_PACKAGE_LIMIT problem.
> 
> This might help here, perhaps (relevant snippets of AML dump):

Indeed, after looking over this horrid ASL stuff for ages I'm now starting
to believe that our IDE controller state is wrong,
since the Match()ing etc. in this particular _GTM implementation
is heavily dependant on actual PCI values
(it references some PCI_Config OperationRegion:s),
and some indexing seems to go wrong due to this.

IOW, it seems very likely that _GTM on these BIOSes (VIA chipsets) isn't
actually wrongly implemented but simply expects IDE controller values
to have been set up ""differently"".


Or... one could possibly even infer from this that - maybe -
the _GTM invocation spot is wrong, it should be done somewhere
different during bootup. Or whatever.



This seems to tell me again that we're often quick to blacklist
or whitelist things left and right when instead fundamental problems
are hidden somewhere.

Still investigating,

Andreas Mohr
