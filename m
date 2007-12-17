Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbXLQSKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbXLQSKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbXLQSKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:10:22 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:41638 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966AbXLQSKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:10:20 -0500
X-Greylist: delayed 860 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2007 13:10:20 EST
Date: Mon, 17 Dec 2007 19:10:17 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       "John Reiser" <jreiser@bitwagon.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, security@kernel.org,
       tytso@mit.edu,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       mpm@selenic.com, linux-sparse@vger.kernel.org
Subject: Re: Signed divides vs shifts (Re: [Security] /dev/urandom uses
 uninit bytes, leaks user data)
Message-Id: <20071217191017.117c61ff.dada1@cosmosbay.com>
In-Reply-To: <2c0942db0712171005w65bbb512p71a4f9b1fc65c6a7@mail.gmail.com>
References: <E1J3RD5-0006yU-00@gondolin.me.apana.org.au>
	<alpine.LFD.0.9999.0712170856050.21557@woody.linux-foundation.org>
	<20071217185557.0b501e23.dada1@cosmosbay.com>
	<2c0942db0712171005w65bbb512p71a4f9b1fc65c6a7@mail.gmail.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 10:05:35 -0800
"Ray Lee" <ray-lk@madrabbit.org> wrote:

> On Dec 17, 2007 9:55 AM, Eric Dumazet <dada1@cosmosbay.com> wrote:
> > -               mid = (last - first) / 2 + first;
> > +       while (low <= high) {
> > +               mid = (low + high) / 2;
> 
> I think you just introduced a bug. Think about what happens if
> low=high=MAX_LONG/2 + 1.
> 

Fortunatly this is not possible :)

Hint : sizeof(struct exception_table_entry) is >= 8

so high is garanteed to be <= MAX_LONG/8

