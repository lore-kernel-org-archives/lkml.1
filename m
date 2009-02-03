Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZBCEKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZBCEKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZBCEKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:10:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbZBCEKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:10:23 -0500
Date: Mon, 2 Feb 2009 20:09:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI PM: Restore standard config registers of all devices early
In-Reply-To: <1233633315.16867.45.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902022008060.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>  <200902022239.02453.rjw@sisk.pl>  <alpine.LFD.2.00.0902021343280.3247@localhost.localdomain>  <200902022331.49131.rjw@sisk.pl>  <alpine.LFD.2.00.0902021508340.3247@localhost.localdomain> 
 <1233633061.16867.41.camel@pasglop> <1233633315.16867.45.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Benjamin Herrenschmidt wrote:
> 
> The new code will basically make the core bring back everything to D0 on
> resume. That's a huge power surge and often not needed at all...

Well, we could easily do it only if it was D0 _before_ resume.

But quite frankly, before I worry about "huge power surge" issues, I want 
to feel like the architecture allows for clueless driver writers, and 
still giving us reliable suspend/resume.

Once we have that reliability, and only _then_, do I care at all about 
power issues. Make it work first, and not result in a dead machine if 
there is unlucky shared interrupt timings.

			Linus
