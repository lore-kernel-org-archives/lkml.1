Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbZH0OOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbZH0OOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZH0OOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:14:03 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49639 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbZH0OOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:14:02 -0400
Subject: Re: Extending virtio_console to support multiple ports
From: Ryan Arnold <rsa@us.ibm.com>
Reply-To: rsa@us.ibm.com
To: Amit Shah <amit.shah@redhat.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, qemu-devel@nongnu.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
       borntraeger@de.ibm.com, linux-kernel@vger.kernel.org, miltonm@bga.com,
       linuxppc-dev@ozlabs.org, brueckner@linux.vnet.ibm.com,
       alan@linux.intel.com
In-Reply-To: <20090827065251.GB3218@amit-x200.redhat.com>
References: <1251181044-3696-1-git-send-email-amit.shah@redhat.com>
	 <20090826112718.GA11117@amit-x200.redhat.com>
	 <20090826154552.GA31910@amit-x200.redhat.com>
	 <1251349485.6267.6.camel@concordia>
	 <20090827065251.GB3218@amit-x200.redhat.com>
Content-Type: text/plain
Organization: IBM
Date: Thu, 27 Aug 2009 09:13:28 -0500
Message-Id: <1251382408.3063.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 12:22 +0530, Amit Shah wrote:
> On (Thu) Aug 27 2009 [15:04:45], Michael Ellerman wrote:
>  Ryan you called his code "pure legacy baggage" if you
> > don't ;)
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commitdiff;h=d450b4ae023fb4be175389c18f4f87677da03020
> 
> Thanks for the link!
> 
> (and this general area might be the one that doesn't get major upheavals
> in 5-yr spans :-)

Actually, quite the opposite... too many cooks in the kitchen in the
last 6 years have left this code with some historical oddities.  When I
added the interrupt context code in the first place I made sure that the
driver did NOTHING in the interrupt handler except awaken the working
thread.  Someone in the subsequent years thought it'd be a good idea to
have the interrupt handler actually do the work.

Furthermore the front and backends were separated so that new front ends
can be used.  This was sometime in the last 5 years as well.

Let's just say I'm happy to pass the torch on this one.

I would suggest that someone perform throughput tests on this driver at
some point.  At the point where I stopped maintaining it I'd gotten the
driver to the point where there was no jerking output or lost data under
heavy I/O load.  I'm not sure where the driver's at now.

Ryan S. Arnold


