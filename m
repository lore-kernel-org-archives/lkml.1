Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbXI1AMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbXI1AMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 20:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759635AbXI1AMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 20:12:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37374 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759629AbXI1AMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 20:12:30 -0400
Message-ID: <46FC46E3.5020508@zytor.com>
Date: Thu, 27 Sep 2007 17:12:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: jkeating@redhat.com, Joerg Pommnitz <pommnitz@yahoo.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: More E820 brokenness
References: <46FC2BFD.6070200@zytor.com> <20070927223336.GB4755@cosmic.amd.com> <46FC32FE.9070302@zytor.com> <20070927231552.GC4755@cosmic.amd.com> <46FC3C5A.2010902@zytor.com> <20070927233408.GD4755@cosmic.amd.com> <46FC3E7C.7060600@zytor.com> <20070927235427.GA18900@cosmic.amd.com>
In-Reply-To: <20070927235427.GA18900@cosmic.amd.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:
> 
> Worked, but that just raises more questions.  Why didn't more x86 boxes
> break or, alternatively, why did a new version of the BIOS fix the problem? 
> I guess we shouldn't look a gift horse in the mouth. Or something.
> 

Why didn't more x86 boxes break... well, it's pretty natural an
implementation of the BIOS to not clobber registers that aren't outputs.
 Arguably the BIOSes that do are still buggy, since there isn't a
well-defined calling sequence for the BIOS and the convention that has
evolved is "don't clobber anything unless it's an output."

It's still wrong, however, especially since it means omitting the *real*
SMAP check.

	-hpa
