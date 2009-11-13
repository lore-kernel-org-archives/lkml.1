Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZKML7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZKML7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbZKML7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:59:46 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:1260 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754466AbZKML7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 06:59:45 -0500
Date: Fri, 13 Nov 2009 12:59:46 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: dedekind1@gmail.com
Cc: David VomLehn <dvomlehn@cisco.com>,
       Marco Stornelli <marco.stornelli@gmail.com>,
       linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com,
       "Shargorodsky Atal (EXT-Teleca/Helsinki)" 
	<ext-atal.shargorodsky@nokia.com>
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
Message-ID: <20091113125946.5353164c@marrow.netinsight.se>
In-Reply-To: <1258112748.21596.1227.camel@localhost>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
	<4AFC4D31.2000101@gmail.com>
	<20091112215649.GA28349@dvomlehn-lnx2.corp.sa.net>
	<20091113091031.3f6d4bba@marrow.netinsight.se>
	<1258112748.21596.1227.camel@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Also fix David Woodhouses address and add Atal)

On Fri, 13 Nov 2009 13:45:48 +0200
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> So we really need to print some user-space supplied information during
> the panic, and then we store it on flash with mtdoops, and the later,
> when the device has network access we send whole bunch of oopses via the
> network.

Yes, I see that your case would have to be handled differently. A
complication (which I believe was discussed before) is that kmsg_dump()
is done before the panic notifiers are called.

The reason I put it there is to have it before crash_kexec(), so I
guess we'll have to take up the discussion on what to do with it. For
me it now seems like it would be OK to move kmsg_dump() down below the
panic notifiers.

If you have a kdump kernel to load, then you will most likely not need
the kmsg dumped data anyway.

// Simon
