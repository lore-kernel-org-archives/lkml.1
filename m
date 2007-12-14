Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbXLNH4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbXLNH4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 02:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbXLNH4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 02:56:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbXLNH4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 02:56:35 -0500
Date: Fri, 14 Dec 2007 02:55:44 -0500
From: Dave Jones <davej@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Adrian Bunk <bunk@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>
Subject: Re: Print taint info in more places.
Message-ID: <20071214075544.GB3234@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Adrian Bunk <bunk@kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@muc.de>
References: <20071213224927.GA18639@redhat.com> <20071214000350.GK21616@stusta.de> <20071214013041.GH22304@redhat.com> <47622FD2.2030607@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47622FD2.2030607@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 11:25:06PM -0800, Jeremy Fitzhardinge wrote:
 > Dave Jones wrote:
 > > On Fri, Dec 14, 2007 at 01:03:50AM +0100, Adrian Bunk wrote:
 > >
 > >  > >  #ifndef HAVE_ARCH_BUG
 > >  > >  #define BUG() do { \
 > >  > > -	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
 > >  > > +	printk(KERN_ERR "BUG: failure at %s:%d/%s()! (%s)\n",
 > >  > > +		__FILE__, __LINE__, __FUNCTION__, print_tainted()); \
 > >  > >  	panic("BUG!"); \
 > >  > >  } while (0)
 > >  > >  #endif
 > >  > >...
 > >  > 
 > >  > Note that this only changes a handful of architectures and most likely 
 > >  > not the ones you are interested in.
 > >
 > > Hmm, it appears that I was mistaken, and we never did patch x86.
 > > Which leaves me wondering if its worth it or not to  patch BUG()
 > > Anyways, here's the latest rev with the out-of-line changes as
 > > suggested by Andi.
 > >
 > > init/main.c may not be the best place for the ool variant. suggestions?
 > >   
 > 
 > lib/bug.c would be the place for architectures using
 > CONFIG_GENERIC_BUG.  x86 could be converted to use the BUG-trapping
 > mechanism for WARN_ON like Power does, so it would be inherently out of
 > line anyway.

The BUG()/WARN_ON() parts of my patch are becoming something of a rathole,
which I don't really have time to dig into right now, so I'm going to split
this up I think into mm/ additions, spinlockdebug additions, and bugon/warnon foo.
The three should be independant, and blocking the first two until I get
time to look at the third seems pointless.

	Dave

-- 
http://www.codemonkey.org.uk
