Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZBDPBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZBDPBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZBDPAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:00:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:33565 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbZBDPAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:00:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,379,1231142400"; 
   d="scan'208";a="428054205"
Subject: Re: [RFC PATCH 09/12] clocksource: allow usage independent of
	timekeeping.c
From: Patrick Ohly <patrick.ohly@intel.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: John Stultz <johnstul@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
In-Reply-To: <1233757792.15119.58.camel@desktop>
References: <1229352899-31330-1-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-2-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-3-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-4-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-5-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-6-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-7-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-8-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-9-git-send-email-patrick.ohly@intel.com>
	 <1229352899-31330-10-git-send-email-patrick.ohly@intel.com>
	 <1229358410.8699.13.camel@jstultz-laptop>
	 <1233757792.15119.58.camel@desktop>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 16:00:49 +0100
Message-Id: <1233759649.15940.209.camel@ecld0pohly>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 14:29 +0000, Daniel Walker wrote:
> On Mon, 2008-12-15 at 08:26 -0800, John Stultz wrote:
> 
> > Nice. The cyclecounter struct can work as a good base that I can shift
> > the clocksource bits over to as I clean that up.
> > 
> > We will probably want to split this out down the road, but for now its
> > small enough and related enough that I think its fine in the
> > clocksource.h/c.
> > 
> > Also since Magnus has been working on it, does enable/disable accessors
> > in the cyclecounter struct make sense for your hardware as well?
> > 
> > Also the corner cases on overflows (how we manage the state, should
> > reads be deferred for too long) will need to be addressed, but I guess
> > we can solve that when it becomes an issue. Just to be clear: none of
> > the hardware you're submitting this round has wrapping issues? Or is
> > that not the case?
> 
> Why wouldn't this just use a clocksource directly and not register it
> with the timekeeping? The cyclecounter is just a subset of the
> clocksource ..

The very first revision of the patch did exactly that:
http://kerneltrap.org/mailarchive/linux-netdev/2008/11/19/4164204

The patch was smaller, but it also took some shortcuts (reusing fields
meant to be used in a different way) and added other unused fields to
the user of such an independent clocksource instance.

I agree with John that separate structures for different aspects of the
problem (abstract API for read-only access to hardware; converting cycle
counter into continuously increasing time counter) is the cleaner
approach.

-- 
Best Regards, Patrick Ohly

The content of this message is my personal opinion only and although
I am an employee of Intel, the statements I make here in no way
represent Intel's position on the issue, nor am I authorized to speak
on behalf of Intel on this matter.

