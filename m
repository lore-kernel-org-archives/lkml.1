Return-Path: <linux-kernel-owner+w=401wt.eu-S1767269AbXCINNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767269AbXCINNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 08:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767274AbXCINNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 08:13:42 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57062 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767269AbXCINNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 08:13:41 -0500
Date: Fri, 9 Mar 2007 15:13:40 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Eric Dumazet <dada1@cosmosbay.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hch@infradead.org, serue@us.ibm.com
Subject: Re: [PATCH 2/7] revoke: add f_light flag for struct file
In-Reply-To: <20070309141246.2059c9dc@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0703091512400.21669@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703091014110.32320@sbz-30.cs.Helsinki.FI>
 <200703091108.58371.dada1@cosmosbay.com> <84144f020703090243j6fd49b5eoa23f4cc12866725a@mail.gmail.com>
 <200703091213.35691.dada1@cosmosbay.com> <84144f020703090352s3ecd8ab4pdde6f24f6cf7cc47@mail.gmail.com>
 <84144f020703090358o76d1d82bk9479792173445fe3@mail.gmail.com>
 <20070309141246.2059c9dc@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At some point in time, I wrote:
> > Btw, what we can do is delay closing the actual revoked file until the
> > task terminates. This has the unfortunate side-effect that a task has
> > no way of freeing the resources now. But, I am beginning to think it's
> > not a big problem because the inode mapping will be zapped immediately
> > upon revoke anyway...
 
On Fri, 9 Mar 2007, Alan Cox wrote:
> Actually you can't entirely do this. The revoke() definition states
> explicitly that the driver close occurs at the point of revoke() not
> later.
> 
> That can however be pushed into the device revoke method for the cases
> where it might matter (eg tty).

Yeah, you just make f_ops->revoke close the driver and f_ops->flush a 
no-op if the driver has already been closed.

			Pekka
