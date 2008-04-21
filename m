Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYDUPGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYDUPGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYDUPGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:06:04 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:22745 "EHLO
	outbound3-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbYDUPGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:06:01 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JZOKLL-01-QFS-01
Date: Mon, 21 Apr 2008 09:12:54 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, jfannin@gmail.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: 2.6.25-mm1
Message-ID: <20080421151254.GC6354@cosmic.amd.com>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <20080419031024.GC3503@nineveh.local> <20080418202925.b18452c5.akpm@linux-foundation.org> <20080419092544.378664a8@ephemeral> <20080419103833.8b609319.akpm@linux-foundation.org> <20080419135047.5f77dfdb@ephemeral> <20080421145619.GA6354@cosmic.amd.com> <20080421110536.44251eb2@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421110536.44251eb2@ephemeral>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 21 Apr 2008 15:05:30.0322 (UTC) FILETIME=[23B63B20:01C8A3C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/04/08 11:05 -0400, Andres Salomon wrote:
> On Mon, 21 Apr 2008 08:56:19 -0600
> Jordan Crouse <jordan.crouse@amd.com> wrote:
> 
> > On 19/04/08 13:50 -0400, Andres Salomon wrote:
> > > On Sat, 19 Apr 2008 10:38:33 -0700
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > > On Sat, 19 Apr 2008 09:25:44 -0400 Andres Salomon <dilinger@queued.net> wrote:
> > > > > On Fri, 18 Apr 2008 20:29:25 -0700
> > > > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > > 
> > > > > > On Fri, 18 Apr 2008 23:10:24 -0400 Joseph Fannin <jfannin@gmail.com> wrote:
> > > > > > 
> > > > > > > On Fri, Apr 18, 2008 at 01:47:57AM -0700, Andrew Morton wrote:
> > > [...]
> > > > > > 
> > > > > > which we probably just shouldn't do this at all unless we're running on the
> > > > > > OLPC hardware.  But we need to do this to find out if we're running on the OLPC
> > > > > > hardware!  Perhaps the warning should just be removed.
> > > > > 
> > > > > Hm.  We could either protect that code with an:
> > > > > 
> > > > > if (!is_geode())
> > > > >   return;
> > > > > 
> > > > > Or I could add the OpenFirmware patches which would allow us to get
> > > > > rid of this code, and instead check for the existence of OFW using
> > > > > that.
> > > > > 
> > > > > The former is quick and easy; the latter is (imo) nicer, so long as
> > > > > people don't have problems w/ the OFW code.  :)
> > > > > 
> > > > 
> > > > Do both ;)
> > > > 
> > > > The quick-n-easy version sounds suitable for now.
> > > 
> > > Heh, I already had sent the nicer version.  If people have some fundamental
> > > problem w/ it, I can send the quick-n-easy version.
> > 
> > I prefer the nicer version.  It is not a good policy IMHO to wrap OLPC
> > specfic code with is_geode() and friends.  Even by Geode standards, we've
> > abused the code greatly for the benefit of the Geode, and few of those
> > abuses would translate very well even to the general Geode community.  I 
> > would prefer that we use the is_olpc() and #ifdef wrappers to ensure
> > that the code that is exclusively OLPC stays exclusively OLPC.
> > 
> > Thanks,
> > Jordan
> > 
> 
> Yeah, like I said; the nicer version is the _correct_ way to do things.  I
> just fear that the OFW code isn't ready for merging (see hpa's concerns).
> 
> The code is already #ifdef'd (the original reporter had enabled
> CONFIG_OLPC), and the code in question is what determines what is_olpc()
> should return.  is_geode() is just to narrow the scope of what hardware
> the check runs on.

My bad, I missed the key points.  This still is dangerous on a generic
Geode, but at least if they encounter the problem, we can loudly proclaim
"Don't do that".

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

