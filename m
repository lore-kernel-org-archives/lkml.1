Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbYFEJMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbYFEJMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYFEJMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:12:39 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50807 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYFEJMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:12:38 -0400
Date: Thu, 5 Jun 2008 11:13:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 4 - firmware/keyspan/mpr.fw.gen.S
Message-ID: <20080605091319.GA17469@uranus.ravnborg.org>
References: <20080604180025.3ecd03ff.sfr@canb.auug.org.au> <48468091.5000102@linux.vnet.ibm.com> <1212586717.32207.71.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212586717.32207.71.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 02:38:37PM +0100, David Woodhouse wrote:
> On Wed, 2008-06-04 at 17:16 +0530, Kamalesh Babulal wrote:
> > Hi Stephen,
> > 
> > The next-20080604 kernel build fails on the x86_64 machine
> > 
> > make[1]: *** No rule to make target `/usr/local/autobench/autotest/tmp/build/linux/$(dir)', needed by `firmware/keyspan/mpr.fw.gen.S'.  Stop.
> > make: *** [firmware] Error 2
> 
> Does this 'fix' it?

The correct fix is to get rid of make 3.81 features.
We do want the kernel buildable with make 3.79 and we have today only two
places where we do need a newer version of make:

	scripts/Makefile.headerinst
and now
	firmware/Makefile

Both places should be reworked to avoid this dependency.
I plan to take care of Makfile.headerinst soonish in an attempt
to speed up the checking process (has been on my TODO list for a long time),

And we should not introuduce the below make 3.81 specific feature.
I have not looked into alternative - sorry.

	Sam
