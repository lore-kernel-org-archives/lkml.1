Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbYHRCGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbYHRCGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 22:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYHRCGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 22:06:08 -0400
Received: from mga05.intel.com ([192.55.52.89]:11477 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750943AbYHRCGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 22:06:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,225,1217833200"; 
   d="scan'208";a="371429374"
Subject: Re: tbench regression on each kernel release from 2.6.22 -> 2.6.28
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: David Miller <davem@davemloft.net>, cl@linux-foundation.org,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808121058550.4551@wrl-59.cs.helsinki.fi>
References: <48A086B6.2000901@linux-foundation.org>
	 <20080811.141501.01468546.davem@davemloft.net>
	 <Pine.LNX.4.64.0808121058550.4551@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 18 Aug 2008 10:05:14 +0800
Message-Id: <1219025114.25933.6.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-08-12 at 11:13 +0300, Ilpo Järvinen wrote: 
> On Mon, 11 Aug 2008, David Miller wrote:
> 
> > From: Christoph Lameter <cl@linux-foundation.org>
> > Date: Mon, 11 Aug 2008 13:36:38 -0500
> > 
> > > It seems that the network stack becomes slower over time? Here is a list of
> > > tbench results with various kernel versions:
> > > 
> > > 2.6.22		3207.77 mb/sec
> > > 2.6.24		3185.66
> > > 2.6.25		2848.83
> > > 2.6.26		2706.09
> > > 2.6.27(rc2)	2571.03
> > > 
> > > And linux-next is:
> > > 
> > > 2.6.28(l-next)	2568.74
> > > 
> > > It shows that there is still have work to be done on linux-next. Too close to
> > > upstream in performance.
> > > 
> > > Note the KT event between 2.6.24 and 2.6.25. Why is that?
> > 
> > Isn't that when some major scheduler changes went in?  I'm not blaming
> > the scheduler, but rather I'm making the point that there are other
> > subsystems in the kernel that the networking interacts with that
> > influences performance at such a low level.
> 
> ...IIRC, somebody in the past did even bisect his (probably netperf) 
> 2.6.24-25 regression to some scheduler change (obviously it might or might 
> not be related to this case of yours)...
I did find much regression with netperf TCP-RR-1/UDP-RR-1/UDP-RR-512. I start
1 serve and 1 client while binding them to a different logical processor in
different physical cpu.

Comparing with 2.6.22, the regression of TCP-RR-1 on 16-core tigerton is:
2.6.23		6%
2.6.24		6%
2.6.25		9.7%
2.6.26		14.5%
2.6.27-rc1	22%

Other regressions on other machines are similar.

yanmin


