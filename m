Return-Path: <linux-kernel-owner+w=401wt.eu-S1750848AbXCUXWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750848AbXCUXWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbXCUXWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:22:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbXCUXWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:22:01 -0400
Date: Wed, 21 Mar 2007 19:19:35 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-ID: <20070321231935.GC9092@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andi Kleen <andi@firstfloor.org>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@stusta.de>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6> <p73y7lu5yt6.fsf@bingen.suse.de> <20070320165736.GA19781@redhat.com> <20070320181442.1ae73295@lxorguk.ukuu.org.uk> <20070321151952.02b5612d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321151952.02b5612d.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 03:19:52PM -0700, Andrew Morton wrote:

 > We've given people years of notice and _some_ applications have converted
 > over to open("/dev/sda1", O_DIRECT), as they should.
 > 
 > Sure, it's a small and simple driver (now), so the cost of maintaining it
 > is low.
 > 
 > But otoh, there's no reason for it to exist, except for userspace
 > sluggishness.
 > 
 > So we can either give up, or we can push on: put a rude printk in there
 > somewhere and who knows, maybe in five years time we can finally be rid of
 > the thing.

We've actually tried to deprecate this twice. First in RHEL4, and more
recently in RHEL5.  The conversations go something like this..

Customer: app xyz doesn't work.
Us: it's using a deprecated API, it needs to be updated to use O_DIRECT
Customer: vendor says "pay us $$$$$ to go to version N+1"

Then we find out the customer can't move to N+1 because they have
some other piece of infrastructure that relies on semantics in the
old version, and screaming and hairpulling ensues.

(And this is one of the more promising conversations. Others
 that have happened with certain db vendors are enough to
 make the pope curse).

Adding printk's on open() of it doesn't solve the problem either.
The people that see them are the customers who run this stuff,
not the people who have the ability to change the code.

If it gets dropped from kernel.org, it wouldn't be long before
it'd find its way back into enterprise vendor kernels.
Isn't it better that we all at least ship the same thing? [1]

	Dave

[1] Though admittedly the one in RHEL deviates from upstream
as it contains performance enhancements that were vetoed from
upstream acceptance due to it being "deprecated".

-- 
http://www.codemonkey.org.uk
