Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbXIEUwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbXIEUwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbXIEUvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:51:53 -0400
Received: from ozlabs.org ([203.10.76.45]:34390 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305AbXIEUvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:51:52 -0400
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
From: Rusty Russell <rusty@rustcorp.com.au>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Patrick McHardy <kaber@trash.net>, adam@yggdrasil.com, jcm@jonmasters.org,
       netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
       Jim Radford <radford@blackbean.org>
In-Reply-To: <20070905192744.GB25050@hmsreliant.think-freely.org>
References: <20070904202433.GA19083@hmsreliant.think-freely.org>
	 <46DEC9BF.9010807@trash.net>
	 <1189008806.10802.150.camel@localhost.localdomain>
	 <20070905170831.GA25050@hmsreliant.think-freely.org>
	 <1189014097.10802.174.camel@localhost.localdomain>
	 <20070905192744.GB25050@hmsreliant.think-freely.org>
Content-Type: text/plain
Date: Thu, 06 Sep 2007 06:51:26 +1000
Message-Id: <1189025486.10802.206.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 15:27 -0400, Neil Horman wrote:
> On Thu, Sep 06, 2007 at 03:41:37AM +1000, Rusty Russell wrote:
> > 	You have this backwards: O_NONBLOCK is the default.  That seems to be
> > what everyone wants, although I implemented 'rmmod -w' because it seemed
> > like a good option.
> > 
> Thats really the point I'm trying to make.  O_NONBLOCK should be the default,
> but it isn't in the case of modprobe.

Ouch, you're right!

And that's been around for a *long* time.  From the original 0.9.2
version (Dec 9th 2002).  ChangeLog says:

	Jim Radford <radford@blackbean.org>'s modprobe -r implementation.

The userspace check still stops most cases of removing used modules.

On the bright side, this one bug has probably done more to deprecate
module removal than any thing else, by making it unreliable...

Good catch!
Rusty.


