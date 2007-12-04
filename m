Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbXLDVQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbXLDVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbXLDVJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:09:50 -0500
Received: from waste.org ([66.93.16.53]:48039 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702AbXLDVJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:09:49 -0500
Date: Tue, 4 Dec 2007 15:08:27 -0600
From: Matt Mackall <mpm@selenic.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       mmcgrath@redhat.com
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204210827.GE19691@waste.org>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com> <20071204165502.0a8f695e@the-village.bc.nu> <20071204180237.GU19691@waste.org> <20071204195021.GB7259@thunk.org> <20071204204036.484f11ac@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204204036.484f11ac@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 08:40:36PM +0000, Alan Cox wrote:
> > Alan, are you sure you're not talking about Helge Deller's attempt to
> > push a Time-based UUID generator into the kernel because you can get
> > duplicates from the current userspace library?
> 
> Yes
> 
> > I've not heard of *any* claim where the kernel uuid random generator
> > has been returning duplicates.
> 
> Then the original reports got lost somewhere.

Pretty sad that such an interesting security bug didn't make it to
either of the /dev/random maintainers.
 
> The Fedora tools use a kernel random uuid for system identifiers (to
> preserve anonymity while allowing system profiles etc to be generated and
> to know which are duplicates).

It's possible that on machines with no real entropy, the initial
startup seeds were having no effect on the /dev/urandom output.
That's fixed here:

http://www.kernel.org/hg/linux-2.6/rev/8298e254985e

which would have been in v2.6.22-rc4 through the normal CVE process.
The only other bits in there are wall time and utsname, so systems
with no CMOS clock would behave repeatably. Can we find out what
kernels are affected?

> We seen a huge number of duplicates for certain values:
> 
> >From Mike McGrath (added to Cc)
> 
> > Here's the top 5:
> >
> >    266 28caf2c3-9766-4fe1-9e4c-d6b0ba8a0132
> >    336 810e7126-1c69-4aff-b8b1-9db0fa8aa15a
> >    402 c8dbb9d3-a9bd-4ba6-b92e-4a294ba5a95f
> >    884 06e84493-e024-44b1-9b32-32d78af04039
> >    931 e2b67e1d-e325-4740-b938-795addb45280
> >
> > The left number is times this month someone has submitted a profile with
> > that UUID.  If we take the last one as an example has come from over 800
> > IP's in the last 20 days.  It seems very unlikely that one person would
> > find his way to 800 different IP's this month.  Let me know if you'd
> > like more.

Any other details would be interesting.

-- 
Mathematics is the supreme nostalgia of our time.
