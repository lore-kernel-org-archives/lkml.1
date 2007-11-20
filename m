Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbXKTUHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbXKTUHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758767AbXKTUHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:07:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43656 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757501AbXKTUHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:07:08 -0500
Date: Tue, 20 Nov 2007 12:06:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard MUSIL <richard.musil@st.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, tpm@selhorst.net
Subject: Re: [PATCH] - TPM device driver layer (tpm.c|h) - 2nd repost
Message-Id: <20071120120651.af5d3159.akpm@linux-foundation.org>
In-Reply-To: <4742D3C6.5000101@st.com>
References: <46CD497F.8030207@st.com>
	<20070823092604.GA6057@kroah.com>
	<46F909CA.3030101@st.com>
	<20071119223746.5f0e938f.akpm@linux-foundation.org>
	<4742D3C6.5000101@st.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 13:32:06 +0100
Richard MUSIL <richard.musil@st.com> wrote:

> >> +	if (chip->vendor.release)
> >> +		chip->vendor.release(dev);
> >> +
> >> +	/* it *should* be: chip->release != NULL */
> > 
> > And that one's actually wrong in the context of kernel coding practices. 
> > But whatever.
> 
> Well I am not sure, what is exactly against coding practices (this is
> my first patch, so bear with me). Was it the comment? Or the "likely".

The code was

	/* it *should* be: chip->release != NULL */
	if (chip->release)

and the I took the comment to mean that it should be

	if (chip->release != NULL)

I was just pointing out that the test-pointer-as-truth-value trick is
smiled upon in kernel coding.

> But, anyway, I guess I was a bit paranoic. chip->release is set to 
> original device::release and this should be set to platform_device_release
> at least (and if someone messed with it, it should not be NULL anyway).
> So I removed complete condition.

>From the above it appears that the code comment misled me.
