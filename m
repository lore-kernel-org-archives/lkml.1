Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbYCYQC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbYCYQC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755908AbYCYQCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:02:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:2772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbYCYQCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:02:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,552,1199692800"; 
   d="scan'208";a="222975068"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch 51/76] ioat: fix ack handling, driver must ensure that ack is zero
Date: Tue, 25 Mar 2008 15:55:23 -0000
Message-ID: <7F38996F7185A24AB9071ED4950AD8C101536C72@swsmsx413.ger.corp.intel.com>
In-Reply-To: <f12847240803250824n5a955bbbtb758820f1d32bad4@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 51/76] ioat: fix ack handling, driver must ensure that ack is zero
Thread-Index: AciOjdHs6TsXT220T3+uc3Oq3jZw8wAALUyw
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: <linux-kernel@vger.kernel.org>, <stable@kernel.org>, <jejb@kernel.org>
Cc: <jmforbes@linuxtx.org>, <zwane@arm.linux.org.uk>, <tytso@mit.edu>,
       <rdunlap@xenotime.net>, <davej@redhat.com>, <chuckw@quantumlinux.com>,
       <reviews@ml.cw.f00f.org>, <mkrufky@linuxtv.org>, <cebbert@redhat.com>,
       <cavokz@gmail.com>, <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>, <alan@lxorguk.ukuu.org.uk>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "Nelson, Shannon" <shannon.nelson@intel.com>, <gregkh@suse.de>
X-OriginalArrivalTime: 25 Mar 2008 15:55:24.0617 (UTC) FILETIME=[A34C2390:01C88E90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---------- Original message ----------
> From: Chris Wright <chrisw@sous-sol.org>
> Date: Mar 21, 2008 11:43 PM
> Subject: [patch 51/76] ioat: fix ack handling, driver must ensure that
> ack is zero
> To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
> Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo
> <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap
> <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber
> <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>,
> Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert
> <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>,
> torvalds@linux-foundation.org, akpm@linux-foundation.org,
> alan@lxorguk.ukuu.org.uk, Dan Williams <dan.j.williams@intel.com>,
> Shannon Nelson <shannon.nelson@intel.com>, Greg Kroah-Hartman
> <gregkh@suse.de>
> 
> 
> -stable review patch.  If anyone has any objections, please let us
know.
> ---------------------
> 
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Initialize 'ack' to zero in case the descriptor has been recycled.
> 
> Prevents "kernel BUG at crypto/async_tx/async_xor.c:185!"
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Acked-by: Shannon Nelson <shannon.nelson@intel.com>
> [chrisw@sous-sol.org: backport to 2.6.24.3]
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
> 
>  drivers/dma/ioat_dma.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/drivers/dma/ioat_dma.c
> +++ b/drivers/dma/ioat_dma.c
> @@ -726,6 +726,7 @@ static struct dma_async_tx_descriptor *i
> 
>        if (new) {
>                new->len = len;
> +               new->async_tx.ack = 0;
>                return &new->async_tx;
>        } else
>                return NULL;
> @@ -749,6 +750,7 @@ static struct dma_async_tx_descriptor *i
> 
>        if (new) {
>                new->len = len;
> +               new->async_tx.ack = 0;
>                return &new->async_tx;
>        } else
>                return NULL;
> 
> --

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

