Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbXBEFIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbXBEFIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 00:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXBEFIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 00:08:46 -0500
Received: from fencepost.gnu.org ([199.232.76.164]:47350 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbXBEFIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 00:08:45 -0500
Subject: Re: [PATCH] fix unaligned exception in
	/drivers/net/wireless/orinoco.c
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070202202039.GA9382@tuxdriver.com>
References: <600D5CB4DFD93545BF61FF01473D11AC0783715B@limkexm2.ad.analog.com>
	 <20070202202039.GA9382@tuxdriver.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 05 Feb 2007 00:08:38 -0500
Message-Id: <1170652118.4191.36.camel@dv.roinet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.5 (2.9.5-4.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-02 at 15:20 -0500, John W. Linville wrote:
> On Thu, Jan 18, 2007 at 09:57:18AM -0000, Hennerich, Michael wrote:
> > 
> > This short patch prevents an unaligned exception to occur. (GCC 4.1)
> > tmp is defined as char pointer while it is later accessed as short.

Signed-off-by: Pavel Roskin <proski@gnu.org>

> This patch seems fine, such as it is.  But, it seems like it might
> also be appropriate to change hermes_read_ltv and/or hermes_read_words
> to not take void * parameters?  This patch would still be needed,
> but it might be more obvious to future coders?

I agree.  If we use any optimization that requires alignment of the
buffer for aligned access, it needs to be clearly specified and
(ideally) enforced.

I've tried to make a patch, but it seems to be a bigger effort than I
expected.  It turns out that hermes_clear_words() is not doing what it
should (although it would only affect some buggy firmwares), and it's
clear that I just cannot replace a couple of arguments and hope for the
best.  I need to dust off my 802.11b cards and re-test everything.

I've started orinoco branch locally, and I hope I'll be able to clean
the driver from all that bitrot soon.

-- 
Regards,
Pavel Roskin

