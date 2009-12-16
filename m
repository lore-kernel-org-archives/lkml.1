Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbZLPRUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbZLPRUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756480AbZLPRUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:20:07 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:40073 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbZLPRUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:20:05 -0500
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMulKEurRN+K/2dsb2JhbADAEZcFhCsEgWM
X-IronPort-AV: E=Sophos;i="4.47,407,1257120000"; 
   d="scan'208";a="229139105"
From: Roland Dreier <rdreier@cisco.com>
To: Ralph Campbell <ralph.campbell@qlogic.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma\@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.33
References: <adaocm1csgb.fsf@roland-alpha.cisco.com>
	<1260821358.19688.296.camel@chromite.mv.qlogic.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Dec 2009 09:20:01 -0800
In-Reply-To: <1260821358.19688.296.camel@chromite.mv.qlogic.com> (Ralph
	Campbell's message of "Mon, 14 Dec 2009 12:09:18 -0800")
Message-ID: <adaws0m96pq.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Dec 2009 17:20:02.0017 (UTC) FILETIME=[00522510:01CA7E74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > I understand your frustration in having to deal with a large amount
 > of code. If you included all the Mellanox firmware in the mlx4
 > driver, it would be huge too. I'm limited in what I can do given
 > the complexity of the IBTA spec.

Sure, I understand that your driver is going to be pretty big.  However,
ipath was ~38 KLoC, which qib is ~54 KLoC (after the latest cleanup --
it started over 60K if I recall correctly).  That's 40% bigger, 16 KLoC
in absolute terms -- and you dropped support for HT HCAs!

 > QLogic is not "abandoning the ipath driver as unmaintainable".
 > The thought was that trying to incrementally patch in all the changes
 > needed to support dual ports, QDR, chip register addresses, etc.
 > would result in larger patches than renaming the driver. It was a
 > chicken-and-egg problem because until the new code was fully
 > written and debugged, we couldn't post it and we couldn't patch
 > ipath until we knew all the places that needed to be changed.

We can quibble about the reason, but the end effect is that ipath is
abandonded, right?  Maybe a better approach would have been to write a
new driver for the new chip and not try to move the old devices out of
ipath.  But of course it's way too late to start over.

Anyway, we'll get qib in eventually -- but it may take some work.

 - R.
