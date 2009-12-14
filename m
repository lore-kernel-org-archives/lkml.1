Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbZLNUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbZLNUJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZLNUJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:09:21 -0500
Received: from avexch1.qlogic.com ([198.70.193.115]:11641 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZLNUJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:09:20 -0500
Subject: Re: InfiniBand/RDMA merge plans for 2.6.33
From: Ralph Campbell <ralph.campbell@qlogic.com>
To: Roland Dreier <rdreier@cisco.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
In-Reply-To: <adaocm1csgb.fsf@roland-alpha.cisco.com>
References: <adaocm1csgb.fsf@roland-alpha.cisco.com>
Content-Type: text/plain
Organization: QLogic
Date: Mon, 14 Dec 2009 12:09:18 -0800
Message-ID: <1260821358.19688.296.camel@chromite.mv.qlogic.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Dec 2009 20:07:53.0148 (UTC) FILETIME=[1E5B47C0:01CA7CF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 10:37 -0800, Roland Dreier wrote:

>  - New QLogic qib driver.  Needs at least one more iteration of
>    cleanups; and I have not had time to look at the latest code in
>    detail to see exactly what cleanups are needed.  I am concerned
>    that QLogic chose to abandon the ipath driver as unmaintainable,
>    and now wants to replace it with an even bigger driver (measured
>    by lines of code) that does not support the HT device that ipath
>    supported.  How can we make sure qib has a longer future?

I understand your frustration in having to deal with a large amount
of code. If you included all the Mellanox firmware in the mlx4
driver, it would be huge too. I'm limited in what I can do given
the complexity of the IBTA spec.

QLogic is not "abandoning the ipath driver as unmaintainable".
The thought was that trying to incrementally patch in all the changes
needed to support dual ports, QDR, chip register addresses, etc.
would result in larger patches than renaming the driver. It was a
chicken-and-egg problem because until the new code was fully
written and debugged, we couldn't post it and we couldn't patch
ipath until we knew all the places that needed to be changed.

We had a pretty strong business requirement to get support for 
our QDR product into OFED 1.5 and the IB interrop tests required
we get something into OFED. The chip schedule just didn't leave time
to debug everything, get it reviewed and then merge with OFED.
Also, I was out for 5 weeks and that delayed the submission to
linux-rdma.

