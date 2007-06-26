Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbXFZPi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbXFZPi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbXFZPiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:38:19 -0400
Received: from outbound-mail-59.bluehost.com ([69.89.20.39]:53248 "HELO
	outbound-mail-59.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757111AbXFZPiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:38:18 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Tue, 26 Jun 2007 08:38:05 -0700
User-Agent: KMail/1.9.7
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200706251434.43863.jesse.barnes@intel.com> <200706251636.53636.jesse.barnes@intel.com> <20070626150249.GA7877@one.firstfloor.org>
In-Reply-To: <20070626150249.GA7877@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706260838.05737.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 26, 2007 8:02:49 am Andi Kleen wrote:
> On Mon, Jun 25, 2007 at 04:36:52PM -0700, Jesse Barnes wrote:
> > On Monday, June 25, 2007 4:34:33 Andi Kleen wrote:
> > > > This patch fixes a bug in the last patch that caused the code to
> > > > run on non-Intel machines (AMD machines apparently don't need it
> > >
> > > Actually the problem can happen on AMD too, but the symptoms can
> > > be different and there can be more wrong than just the MTRRs.
> >
> > I should have been more specific in the changelog.  My understanding is
> > that AMD systems don't need it for memory above 4G, and since the code
>
> AMD systems need MTRRs to get cached memory too, or what is your point?

My point is that yes, this problem can happen on AMD, but the code doesn't 
handle the problems that AMD systems might have, since it doesn't look for 
problems in low memory (e.g. if you have an AMD system with 6G of memory, the 
code will probably trim everything above 4G since it doesn't know about the 
new AMD mapping stuff from RevE), as Eric pointed out.

Both you and Eric say you've seen AMD systems with problems, but handling them 
would make the code more complex than it is now, and I haven't seen the 
actual reports (memory maps & MTRR setups) so I can't really fix them anyway.  
And since this patch solves real problems as-is, it seems like we should push 
it upstream then rework it, if necessary (i.e. real user machines with this 
problem) later.

What do you think?

Jesse
