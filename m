Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbYLGERY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbYLGERY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 23:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYLGERQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 23:17:16 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:38162 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753544AbYLGERP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 23:17:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABvcOkl5LJfT/2dsb2JhbADMXIMF
X-IronPort-AV: E=Sophos;i="4.33,727,1220193000"; 
   d="scan'208";a="270850768"
Date: Sun, 7 Dec 2008 15:17:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
	barriers.)
Message-ID: <20081207041711.GA22525@disturbed>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, Alasdair G Kergon <agk@redhat.com>,
	Andi Kleen <andi-suse@firstfloor.org>,
	Milan Broz <mbroz@redhat.com>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com> <20081204100050.GN6703@one.firstfloor.org> <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com> <20081204142015.GQ6703@one.firstfloor.org> <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com> <20081204145810.GR6703@one.firstfloor.org> <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 11:45:44AM -0500, Mikulas Patocka wrote:
> > The write block with barrier bit varies, jbd/gfs2 do it synchronously
> > too and xfs does it asynchronously (with io done callbacks), but
> 
> And how does xfs preserve write ordering, if the barrier asynchronously 
> fails with -EOPNOTSUPP and there are other writes submitted after the 
> barrier?

Doesn't matter. XFS executes journal state changes during the I/O
completion callbacks a layer above this resubmit code. Hence,
if the I/O is resubmitted before the completion callbacks are
run, it just appears that the I/O has taken longer than expected
and the state change is delayed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
