Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbZAPKnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbZAPKnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932719AbZAPKnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:43:15 -0500
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:27153 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932691AbZAPKnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:43:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bKltltkxU55t66wWZfBwzZaGntcB82UoUT4c4hT1aU4dwN5pcRifnqFLqANSPtnfZvDlzD5YUNiP/VWpykLs6VWf/HyJT+1jOX4eg/T236wy0d5r1dYsssSP07CMVz7oeENE3m24HZRyjwMmmHp5Sarh0q5kX5UEWCDiBsnOM1Q=  ;
X-YMail-OSG: uWaAoaMVM1lb._.OhxlemXQhYOdvZ_V0KdPlnKHaMZoknsTNH4MxObRTWXz7_iM.BYbMXZFSMXdPs6V0tBK.iRLPjkx6gSVqC5EDFoKbxJg4aEapln6PwoeaH6AgF1cjhyYB6XJgPUN5DDxFwRzM87UW9HqgOo1J17CYdh2wWuKbhvELu4wLgKFXS6EMXHD4pYUkoMJBJKf58H_.ZWhAYMccIacKClR7EHI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: Mainline kernel OLTP performance update
Date: Fri, 16 Jan 2009 21:42:49 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: "Matthew Wilcox" <matthew@wil.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       "Andrew Vasquez" <andrew.vasquez@qlogic.com>,
       "Anirban Chakraborty" <anirban.chakraborty@qlogic.com>,
       "Christoph Lameter" <cl@linux-foundation.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <200901162121.09128.nickpiggin@yahoo.com.au> <84144f020901160231k9e896d2o672079c1a2973632@mail.gmail.com>
In-Reply-To: <84144f020901160231k9e896d2o672079c1a2973632@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901162142.51306.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009 21:31:03 Pekka Enberg wrote:
> On Friday 16 January 2009 21:16:31 Pekka Enberg wrote:
> >> I had lockdep enabled in my config so I ran the tests again with
> >> x86-64 defconfig and I'm back to square one:
> >>
> >>   [ number of transactions per second from 10 runs, bigger is better ]
> >>
> >>                    min      max      avg      sd
> >>   2.6.29-rc1-slab  802.02   805.37   803.93   0.97
> >>   2.6.29-rc1-slub  807.78   811.20   809.86   1.05
>
> On Fri, Jan 16, 2009 at 12:21 PM, Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > Hm, I wonder why it is going slower with lockdep disabled?
> > Did something else change?
>
> I don't have the exact config for the previous tests but it's was just
> my laptop regular config whereas the new tests are x86-64 defconfig.
> So I think I'm just hitting some of the other OLTP regressions here,
> aren't I? There's some scheduler related options such as
> CONFIG_GROUP_SCHED and CONFIG_FAIR_GROUP_SCHED enabled in defconfig
> that I didn't have in the original tests. I can try without them if
> you want but I'm not sure it's relevant for SLAB vs SLUB tests.

Oh no that's fine. It just looked like you repeated the test but
with lockdep disabled (and no other changes).


