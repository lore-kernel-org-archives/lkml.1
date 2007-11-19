Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbXKSKeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbXKSKeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 05:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXKSKeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 05:34:04 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:38562 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751715AbXKSKeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 05:34:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TPF6WrQZ/ULmWiOo7DokwQSpPTDtU/XFEmtGSAQ59w9s00eJ5Xoq302o2PcMqYaMQ5dlXobawOreDwXI9SzxPml2xPBGaZKsboaTczf7Fc86l/t+vzJnVtGEYxyb7jqZfRnPdFiYqBe0pA3D24OW/Kq7yb9iete79cKWVrT81hs=
Message-ID: <9c9fda240711190234q357f2ec5v3def4601355ea23d@mail.gmail.com>
Date: Mon, 19 Nov 2007 19:34:02 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [PATCH] Clustering indirect blocks in Ext3
Cc: "Abhishek Rai" <abhishekrai@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Andreas Dilger" <adilger@sun.com>, linux-kernel@vger.kernel.org,
       "Ken Chen" <kenchen@google.com>, "Mike Waychison" <mikew@google.com>
In-Reply-To: <20071118204724.GS19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9885f0f0711152102h7a8270bfvd65605d8c00e6754@mail.gmail.com>
	 <20071115230219.1fe9338c.akpm@linux-foundation.org>
	 <20071116073716.GB17536@waste.org>
	 <d9885f0f0711180752o71561745h51f2a18d09709e27@mail.gmail.com>
	 <20071118204724.GS19691@waste.org>
X-Google-Sender-Auth: 88d2392c314b3a94
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> >
> > Setup: 4 cpu, 8GB RAM, 400GB disk.
> >
> > Average vanilla results
> > ==========================================================================
> > intial create total runs 30 avg 46.49 MB/s (user 1.12s sys 2.25s)
> > create total runs 5 avg 12.90 MB/s (user 1.08s sys 1.97s)
> > patch total runs 4 avg 8.70 MB/s (user 0.60s sys 2.31s)
> > compile total runs 7 avg 21.44 MB/s (user 0.32s sys 2.95s)
> > clean total runs 4 avg 59.91 MB/s (user 0.05s sys 0.26s)
> > read tree total runs 2 avg 21.85 MB/s (user 1.12s sys 2.89s)
> > read compiled tree total runs 1 avg 23.47 MB/s (user 1.45s sys 4.89s)
> > delete tree total runs 2 avg 13.18 seconds (user 0.64s sys 1.02s)
> > no runs for delete compiled tree
> > stat tree total runs 4 avg 4.76 seconds (user 0.70s sys 0.50s)
> > stat compiled tree total runs 1 avg 7.84 seconds (user 0.74s sys 0.54s)
> >
> > Average metaclustering results
> > ==========================================================================
> > intial create total runs 30 avg 45.04 MB/s (user 1.13s sys 2.42s)
> > create total runs 5 avg 15.64 MB/s (user 1.08s sys 1.98s)
> > patch total runs 4 avg 10.50 MB/s (user 0.61s sys 3.11s)
> > compile total runs 7 avg 28.07 MB/s (user 0.33s sys 4.06s)
> > clean total runs 4 avg 83.27 MB/s (user 0.04s sys 0.27s)
> > read tree total runs 2 avg 21.17 MB/s (user 1.15s sys 2.91s)
> > read compiled tree total runs 1 avg 22.79 MB/s (user 1.38s sys 4.89s)
> > delete tree total runs 2 avg 9.23 seconds (user 0.62s sys 1.01s)
> > no runs for delete compiled tree
> > stat tree total runs 4 avg 4.72 seconds (user 0.71s sys 0.50s)
> > stat compiled tree total runs 1 avg 6.50 seconds (user 0.79s sys 0.53s)
> >
> > Overall, metaclustering does better than vanilla except in a few cases.
>

I think above testcases are just run with normal I/O case.
Did you test the direct I/O test with this patch?
With metaclustering patch, I can't run 'fsstress' since it oops when direct I/O.
or is it dependent on other ext3 patches?
Since I tested it with latest kernel 2.6.24-rc3 instead of mm kernel.

Thank you,
Kyungmin Park
