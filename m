Return-Path: <linux-kernel-owner+w=401wt.eu-S1764700AbYBZXC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764700AbYBZXC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbYBZXCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:02:47 -0500
Received: from ra.tuxdriver.com ([70.61.120.52]:4369 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbYBZXCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:02:46 -0500
Date: Tue, 26 Feb 2008 17:47:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, Ingo Molnar <mingo@elte.hu>,
       Alexey Zaytsev <zaytsev.a@protei.ru>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Message-ID: <20080226224757.GB3100@tuxdriver.com>
References: <47BEAF3B.3080809@protei.ru> <20080226202044.GE3013@tuxdriver.com> <f19298770802261338r40e3f252j2249c1325b725614@mail.gmail.com> <200802262304.39882.mb@bu3sch.de> <f19298770802261412j7a3fec4bv1754db8123796d54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19298770802261412j7a3fec4bv1754db8123796d54@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 01:12:32AM +0300, Alexey Zaytsev wrote:
> On Wed, Feb 27, 2008 at 1:04 AM, Michael Buesch <mb@bu3sch.de> wrote:

> >  Besides that the bcm43xx driver is not broken. That's the whole reason
> >  this damn thread started at all. So it can't be broken.
> >
> Can't agree here. The bcm43xx driver used to work with 2.6.23 without requiring
> any module magic.

At the risk of prolonging things... :-(

Isn't the fundamental problem here that the ssb driver claims the same
PCI IDs as the bcm43xx driver?  He have hit this same issue a number
of times: 8139too vs.  8139cp, eepro vs. e100, sk98lin vs. skge,
and I'm sure there are more.  I admit that this situation is a bit
more confusing, since the user is less likely to predict a conflict
between bcm43xx and the ssb driver.  This is especially true since
the user isn't even selecting ssb directly, but is instead selecting
the apparently unrelated b44.

Still, the bcm43xx driver is not fundamentally damaged.  This is
fundamentally a "two drivers claiming the same PCI ID" issue, not a
"you broke my driver" one.

John
-- 
John W. Linville
linville@tuxdriver.com
