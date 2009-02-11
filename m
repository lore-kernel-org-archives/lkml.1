Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZBKWOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZBKWOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbZBKWNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:13:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:39680 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774AbZBKWNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:13:53 -0500
Subject: RE: [PATCH]iwlan dma mapping read and write changes
From: David Woodhouse <dwmw2@infradead.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Yu, Fenghua" <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F04F633E2FA@hasmsx504.ger.corp.intel.com>
References: <20081001165606.GA21279@linux-os.sc.intel.com>
	 <20090211182648.GA1661@linux-os.sc.intel.com>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2CD@hasmsx504.ger.corp.intel.com>
	 <1234388027.16004.50.camel@johannes.local>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2D5@hasmsx504.ger.corp.intel.com>
	 <1234388845.16004.53.camel@johannes.local>
	 <1234389007.16004.55.camel@johannes.local>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2FA@hasmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 22:13:33 +0000
Message-Id: <1234390413.3586.85.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 00:10 +0200, Winkler, Tomas wrote:
> 
> >-----Original Message-----
> >From: Johannes Berg [mailto:johannes@sipsolutions.net]
> >Sent: Wednesday, February 11, 2009 11:50 PM
> >To: Winkler, Tomas
> >Cc: Yu, Fenghua; David Woodhouse; Ingo Molnar; Stephen Rothwell; Grumbach,
> >Emmanuel; Zhu, Yi; Chris Wright; LKML; iommu@lists.linux-foundation.org
> >Subject: RE: [PATCH]iwlan dma mapping read and write changes
> >
> >On Wed, 2009-02-11 at 22:47 +0100, Johannes Berg wrote:
> >> > >> Indeed the firmware/ucode write back to host memory to update retry
> >> > >> counter for APMDU packets. I'm not sure if this is needed for legacy
> >> > >> traffic, though.
> >> > >
> >> > >I don't think they can be seeing AMPDU packets since that is, well,
> >> > >broken?
> >> >
> >> > Currently I'm not aware of any other cases where memory is accessed
> >> > back but I may have not complete info.  Will be back with the answer
> >> > tomorrow.
> >>
> >> I don't think it really matters, since AMPDU packets will be fixed soon,
> >> and for those you know it's necessary (and the report says that under
> >> some other circumstances it's also necessary). Unless there'd be some
> >> benefit from using BIDI only when we know it'll be needed, and using
> >> TODEV in the other cases?
> >
> >Or if there's a firmware bug.
> 
> That's why it's better to clear the picture. 
> Fenghua
> What exact HW do you get this error?

Lenovo T400.

00:00.0 0600: 8086:2a40 (rev 07)
00:02.0 0300: 8086:2a42 (rev 07)
00:02.1 0380: 8086:2a43 (rev 07)
00:03.0 0780: 8086:2a44 (rev 07)
00:03.2 0101: 8086:2a46 (rev 07)
00:03.3 0700: 8086:2a47 (rev 07)
00:19.0 0200: 8086:10f5 (rev 03)
00:1a.0 0c03: 8086:2937 (rev 03)
00:1a.1 0c03: 8086:2938 (rev 03)
00:1a.2 0c03: 8086:2939 (rev 03)
00:1a.7 0c03: 8086:293c (rev 03)
00:1b.0 0403: 8086:293e (rev 03)
00:1c.0 0604: 8086:2940 (rev 03)
00:1c.1 0604: 8086:2942 (rev 03)
00:1c.2 0604: 8086:2944 (rev 03)
00:1c.3 0604: 8086:2946 (rev 03)
00:1c.4 0604: 8086:2948 (rev 03)
00:1d.0 0c03: 8086:2934 (rev 03)
00:1d.1 0c03: 8086:2935 (rev 03)
00:1d.2 0c03: 8086:2936 (rev 03)
00:1d.7 0c03: 8086:293a (rev 03)
00:1e.0 0604: 8086:2448 (rev 93)
00:1f.0 0601: 8086:2917 (rev 03)
00:1f.2 0106: 8086:2929 (rev 03)
00:1f.3 0c05: 8086:2930 (rev 03)
03:00.0 0280: 8086:4236 
04:00.0 0580: 8086:444e (rev 11)
15:00.0 0607: 1180:0476 (rev ba)
15:00.1 0c00: 1180:0832 (rev 04)

-- 
dwmw2

