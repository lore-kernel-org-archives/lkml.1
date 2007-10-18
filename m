Return-Path: <linux-kernel-owner+w=401wt.eu-S1765828AbXJRPcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765828AbXJRPcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760672AbXJRPbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:31:51 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36403 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934034AbXJRPbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:31:49 -0400
Date: Thu, 18 Oct 2007 08:30:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, sds@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, morgan@kernel.org,
       linux-kernel@vger.kernel.org, kaigai@kaigai.gr.jp,
       casey@schaufler-ca.com
Subject: Re: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
Message-ID: <20071018153043.GB3906@sequoia.sous-sol.org>
References: <20071016022730.GA8925@sergelap.austin.ibm.com> <20071016023100.GA10698@sergelap.austin.ibm.com> <1192544299.8702.78.camel@moss-spartans.epoch.ncsc.mil> <20071016214159.GB13294@sergelap.austin.ibm.com> <20071017180002.33fe4986.akpm@linux-foundation.org> <20071018025920.GA5067@vino.hallyn.com> <20071018052111.GQ3906@sequoia.sous-sol.org> <20071018125026.GA10387@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018125026.GA10387@vino.hallyn.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Serge E. Hallyn (serge@hallyn.com) wrote:
> Quoting Chris Wright (chrisw@sous-sol.org):
> > * Serge E. Hallyn (serge@hallyn.com) wrote:
> > > I guess now that I've written this out, it seems pretty clear
> > > that capget64() and capget64() are the way to go.  Any objections?
> > 
> > How is capget64() different from capget() that supports 2 different
> > header->versions (I thought that was the whole point of the versioned,
> > rather opaque interface)?  I don't object to a new syscall, but I don't
> > see why it's required to avoid breaking libcap.
> 
> Hmm, I guess it *works*, it's just harder to explain the "inconsistent"
> behavior.  Now instead of saying "capget() will fail under certain
> conditions while capget64() will always succeed", capget() will actually
> fail under certain conditions only if you send in a certain header.
> 
> Again, once I've written it out, I guess it isn't *so* bad.

It's not really any different than issuing capget(0x19980330) (assuming
capget64 is different), and getting -EINVAL when the actual in-use
caps are > 32 bits wide.  In either case the rules are the same --
old interface works fine as long as you don't have new caps involved.
Only advantage I see to using the extant interface is that the cap[sg]et
interface is already designed to be future-proof (albeit in an unusual
way compared with most other kernel syscalls).

thanks,
-chris
